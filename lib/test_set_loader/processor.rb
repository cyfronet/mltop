class TestSetLoader::Processor
  RESTRICTED_TEST_SETS = %w[ MUSTC MTEDX LRS2 LRS3 ].freeze

  attr_reader :dir, :challenge_id

  def initialize(dir, challenge_id, test_sets_yaml_path)
    @dir = dir
    @challenge_id = challenge_id
    @test_sets_yaml_path = test_sets_yaml_path
  end

  def self.for(dir, challenge_id, test_sets_yaml_path)
    clazz =
      case dir.basename.to_s
      when "MT"  then  TestSetLoader::MtProcessor
      when "ASR" then  TestSetLoader::AsrProcessor
      when "SQA" then  TestSetLoader::SqaProcessor
      when "ST"  then  TestSetLoader::StProcessor
      when "SUM" then  TestSetLoader::SumProcessor
      when "SSUM" then TestSetLoader::SsumProcessor
      when "SLU" then TestSetLoader::SluProcessor
      when "LIPREAD" then TestSetLoader::LipreadProcessor
      else TestSetLoader::UnknownProcessor
      end

    clazz.new(dir, challenge_id, test_sets_yaml_path)
  end

  def import!
    raise "Should be implemented by descendent class"
  end

  private
    def single_language_process(dir, &block)
      language_process(dir) do |test_set, name, entry|
        lang = entry.basename.to_s
        create_or_update_entry(test_set, lang, lang) do
          block.call(entry, name, lang)
        end
      end
    end

    def from_to_language_process(dir, &block)
      language_process(dir) do |test_set, name, entry|
        source, target = entry.basename.to_s.split("-")
        create_or_update_entry(test_set, source, target) do
          block.call(entry, name, source, target)
        end
      end
    end

    def language_process(dir, &block)
      test_set = test_sets(dir)

      dir.each_child do |entry|
        next if entry.file?
        name = dir.basename.to_s

        block.call(test_set, name, entry)
      end
    end

    def slug
      dir.basename.to_s
    end

    def not_supported(entry)
      error "Test set #{entry.basename} not supported for #{slug}"
    end

    def test_sets(dir)
      name = dir.basename.to_s

      ts = TestSet.find_or_initialize_by(name:).tap do |ts|
        ts.assign_attributes(
          description: description(name, dir),
          published: !RESTRICTED_TEST_SETS.include?(name.upcase),
          challenge_id:
        )
        ts.save
      end

      TestSet.includes(entries: [ :input_blob, :groundtruth_blob, :internal_blob ]).find(ts.id)
    end

    def create_or_update_entry(test_set, source_language, target_language, &block)
      input, groundtruth, internal = block.call
      task_test_set = task.task_test_sets.find_or_create_by!(test_set:)

      if entry = task_test_set.test_set_entries.detect { |e| e.source_language == source_language && e.target_language == target_language }
        warning "Entry for #{slug}/#{test_set.name} #{source_language} -> #{target_language} already exists. Updating groundtruth and internal files."

        to_update = {}

        if input && file_changed?(entry.input_blob, input)
          info "  - input will be updated"
          to_update[:groundtruth] = { io: input.open, filename: input.basename }
        end

        if groundtruth && file_changed?(entry.groundtruth_blob, groundtruth)
          info "  - groundtruth will be updated"
          to_update[:groundtruth] = { io: groundtruth.open, filename: groundtruth.basename }
        end

        if internal && file_changed?(entry.internal_blob, internal)
          info "  - internal will be updated"
          to_update[:internal] = { io: internal.open, filename: internal.basename }
        end

        if to_update.empty?
          info " input, groundtruth and internal files are the same"
        else
          entry.update!(to_update)
        end
      else
        info "Creating entry for #{slug}/#{test_set.name} #{source_language} -> #{target_language}"

        hsh = {
          task:,
          source_language:,
          target_language:,
          input: { io: input.open, filename: input.basename },
          groundtruth: { io: groundtruth.open, filename: groundtruth.basename }
        }

        if internal
          hsh[:internal] = { io: internal.open, filename: internal.basename }
        end

        task_test_set.test_set_entries.create!(hsh)
      end
    end

    def file_changed?(blob, io)
      blob.checksum != ActiveStorage::Blob.new.send(:compute_checksum_in_chunks, io.open)
    end


    def task
      @task ||= Task.find_by!(slug:)
    end

    def child_with_extension(dir, extension)
      dir.children.detect { |child| child.basename.to_s.ends_with?(extension) }
    end

    def archive_with_extensions(dir, extensions:, name:)
      files = dir.children.select do |child|
        extensions.any? { |ext| child.basename.to_s.ends_with?(ext) }
      end

      archive_location = File.join(dir, name)
      system "tar -C #{dir} -cf #{archive_location} #{files.map(&:basename).join(" ")}"

      Pathname.new(archive_location)
    end

    def info(msg)
      puts "\e[#{32}m  - #{msg}\e[0m"
    end

    def warning(msg)
      puts "\e[#{33}m  - #{msg}\e[0m"
    end

    def error(msg)
      puts "\e[#{31}m  - #{msg}\e[0m"
    end

    def description(name)
      child_with_extension(dir, "_description.txt")&.read ||
        descriptions[name].try(:[], "description") ||
        "TODO: please update test set description"
    end

    def descriptions
      @descriptions ||= YAML.load_file(@test_sets_yaml_path)
    end
end
