class TestSetLoader::SqaProcessor < TestSetLoader::Processor
  def import!
    for_each_test_set do |entry|
      case entry.basename.to_s
      when "SPOKENSQUAD" then process_spokensquad(entry)
      else                    not_supported(entry)
      end
    end
  end

  private
    def process_spokensquad(dir)
      single_language_process(dir) do |entry, _name, _lang|
        [
          child_with_extension(entry, "tar.gz"),
          child_with_extension(entry, "json")
        ]
      end
    end
end
