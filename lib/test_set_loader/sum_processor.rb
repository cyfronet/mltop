class TestSetLoader::SumProcessor < TestSetLoader::Processor
  def import!
    dir.each_child do |entry|
      next if entry.file?

      case entry.basename.to_s
      when "ICSI"    then process_icsi(entry)
      when "AUTOMIN" then process_automin(entry)
      else                not_supported(entry)
      end
    end
  end

  private
    def process_icsi(dir)
      single_language_process(dir) do |entry, name, lang|
        [
          child_with_extension(entry, "src.jsonl"),
          child_with_extension(entry, "ref.jsonl")
        ]
      end
    end

    def process_automin(dir)
      single_language_process(dir) do |entry, name, lang|
        [
          child_with_extension(entry, "src.jsonl"),
          child_with_extension(entry, "ref.jsonl")
        ]
      end
    end
end
