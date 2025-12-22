class GroupSubmissionProcessor
  class InvalidStructureError < StandardError; end
  class InvalidTaskError < StandardError; end
  def initialize(group_submission)
    @group_submission = group_submission
    @model = group_submission.model
    @hypotheses_map = {}
  end

  def process
    @group_submission.file.open do |temp_file|
      Zip::File.open(temp_file.path) do |zip_file|
        build_hypotheses(zip_file)
        link_entries_and_save
      end
    end
  end

  private

    def build_hypotheses(zip_file)
      task_names = @model.tasks.pluck(:name)
      top_level_names = zip_file.entries.map(&:name).map { |n| n.split("/").first }.uniq
      if top_level_names.nil? || top_level_names&.empty?
        @group_submission.update!(state: "failed", error_message: "ZIP file is empty or has invalid structure")
        return
      end
      invalid_task_names = top_level_names - task_names
      if invalid_task_names.any?
        @group_submission.update!(state: "failed", error_message: "Invalid tasks #{invalid_task_names.join(", ")}")
        return
      end

      zip_file.entries.select(&:file?).each do |entry|
        names = entry.name.split("/")
        if names.size != 3
          @group_submission.update!(state: "failed", error_message: "Submitted file is empty or has invalid structure")
          return
        end

        task, test_set, filename = names
        next unless task_names.include?(task)

        lang_pair = File.basename(filename, ".*")
        @hypotheses_map["#{task}/#{test_set}/#{lang_pair}"] = Hypothesis.new(
          model: @model,
          group_submission: @group_submission,
          input: {
            io: StringIO.new(entry.get_input_stream.read),
            filename: entry.name,
            content_type: Marcel::MimeType.for(extension: File.extname(entry.name))
          }
        )
      end
      @group_submission.update!(state: "success")
    end

    def link_entries_and_save
      ActiveRecord::Base.transaction do
        test_set_entries.each do |tse|
          key = "#{tse.task.name}/#{tse.test_set.name}/#{tse.source_language}_#{tse.target_language}"

          if (hypothesis = @hypotheses_map[key])
            hypothesis.test_set_entry = tse
            hypothesis.save!
          end
        end
      end
    end

    def test_set_entries
      TestSetEntry.joins(:task, :test_set)
          .where(tasks: { name: task_names })
          .where(test_sets: { name: test_set_names })
    end

    def task_names
      @hypotheses_map.keys.map { |k| k.split("/")[0] }.uniq
    end

    def test_set_names
      @hypotheses_map.keys.map { |k| k.split("/")[1] }.uniq
    end
end
