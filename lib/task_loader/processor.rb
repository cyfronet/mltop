class TaskLoader::Processor
  attr_reader :dir

  def initialize(dir)
    @dir = dir
  end

  def self.for(dir)
    clazz =
      case dir.basename.to_s
      when "MT"  then TaskLoader::MtProcessor
      when "ASR" then TaskLoader::AsrProcessor
      when "SQA" then TaskLoader::SqaProcessor
      when "ST"  then TaskLoader::StProcessor
      when "SUM" then TaskLoader::SumProcessor
      when "SSUM" then TaskLoader::SsumProcessor
      else            TaskLoader::UnknownProcessor
      end

    clazz.new(dir)
  end

  def import!
    raise "Should be implemented by descendent class"
  end

  private
    def single_language_process(dir, &block)
      language_process(dir) do |test_set, name, entry|
        lang = entry.basename.to_s
        create_entry_when_missing(test_set, lang, lang) do
          block.call(entry, name, lang)
        end
      end
    end

    def from_to_language_process(dir, &block)
      language_process(dir) do |test_set, name, entry|
        source, target = entry.basename.to_s.split("-")
        create_entry_when_missing(test_set, source, target) do
          block.call(entry, name, source, target)
        end
      end
    end

    def language_process(dir, &block)
      name = dir.basename.to_s
      test_set = test_sets(name)

      dir.each_child do |entry|
        next if entry.file?

        block.call(test_set, name, entry)
      end
    end

    def slug
      dir.basename.to_s
    end

    def not_supported(entry)
      error "Test set #{entry.basename} not supported yet for #{slug}"
    end

    def test_sets(name)
      TestSet.find_or_create_by!(name:) do |ts|
        ts.description = "TODO: please update test set description"
      end
    end

    def create_entry_when_missing(test_set, source_language, target_language, &block)
      if test_set.entries.exists?(source_language:, target_language:, task:)
        warning "Entry for #{slug}/#{test_set.name} #{source_language} -> #{target_language} already exists."
      else
        info "Creating entry for #{slug}/#{test_set.name} #{source_language} -> #{target_language}"
        input, groundtruth = block.call

        test_set.entries.create!(
          task:,
          source_language:,
          target_language:,
          input: { io: input.open, filename: input.basename },
          groundtruth: { io: groundtruth.open, filename: groundtruth.basename })
      end
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
end
