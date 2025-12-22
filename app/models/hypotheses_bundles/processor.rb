class HypothesesBundles::Processor
  def initialize(hypotheses_bundle)
    @hypotheses_bundle = hypotheses_bundle
    @model = hypotheses_bundle.model
    @hypotheses_map = {}
  end

  def process
    @hypotheses_bundle.archive.open do |temp_file|
      Zip::File.open(temp_file.path) do |zip_file|
        return unless validate_zip_structure(zip_file)

        build_hypotheses(zip_file)
        link_entries_and_save
      end
    end
    @hypotheses_bundle.update!(state: "success") unless @hypotheses_bundle.state == "failed"
  end

  private
    def validate_zip_structure(zip_file)
      model_task_slugs = @model.tasks.pluck(:slug)
      top_level_names = zip_file.entries.reject(&:file?).map(&:name).map { |n| n.split("/").first }.uniq

      if top_level_names.blank?
        fail_bundle!("Submitted file is empty or has invalid structure")
        return false
      end

      invalid_task_slugs = top_level_names - model_task_slugs
      if invalid_task_slugs.any?
        fail_bundle!("Invalid tasks: #{invalid_task_slugs.join(', ')}")
        return false
      end

      zip_file.entries.select(&:file?).each do |entry|
        if entry.name.split("/").size != 3
          fail_bundle!("Submitted file is empty or has invalid structure")
          return false
        end
      end

      true
    end

    def fail_bundle!(message)
      @hypotheses_bundle.update!(state: "failed", error_message: message)
    end

    def build_hypotheses(zip_file)
      zip_file.entries.select(&:file?).each do |entry|
        task, test_set, filename  = entry.name.split("/")

        lang_pair = File.basename(filename, ".*")
        @hypotheses_map["#{task}/#{test_set}/#{lang_pair}"] = Hypothesis.new(
          model: @model,
          hypotheses_bundle: @hypotheses_bundle,
          input: {
            io: StringIO.new(entry.get_input_stream.read),
            filename: entry.name,
            content_type: Marcel::MimeType.for(extension: File.extname(entry.name))
          }
        )
      end

      @hypotheses_bundle.update!(state: "success")
    end

    def link_entries_and_save
      ActiveRecord::Base.transaction do
        test_set_entries.each do |tse|
          key = "#{tse.task.slug}/#{tse.test_set.name}/#{tse.source_language}_#{tse.target_language}"

          if (hypothesis = @hypotheses_map[key])
            hypothesis.test_set_entry = tse
            hypothesis.save!
          end
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      @hypotheses_bundle.update!(state: "failed", error_message: "#{e.record.input.filename} - Hypothesis for this task and test set is already present")
    end

    def test_set_entries
      TestSetEntry.joins(:task, :test_set)
          .where(tasks: { slug: task_slugs })
          .where(test_sets: { name: test_set_names })
    end

    def task_slugs
      @hypotheses_map.keys.map { |k| k.split("/")[0] }.uniq
    end

    def test_set_names
      @hypotheses_map.keys.map { |k| k.split("/")[1] }.uniq
    end
end
