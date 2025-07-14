class TestSetLoader::SsumProcessor < TestSetLoader::Processor
  def import!
    for_each_test_set do |entry|
      case entry.basename.to_s
      when "ICSI"    then process_icsi(entry)
      else                not_supported(entry)
      end
    end
  end

  private
    def process_icsi(dir)
      single_language_process(dir) do |entry, name, lang|
        [
          child_with_extension(entry, "audios.tar.gz"),
          child_with_extension(entry, "ref.jsonl")
        ]
      end
    end
end
