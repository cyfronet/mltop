class TestSetLoader::LipreadProcessor < TestSetLoader::Processor
  def import!
    for_each_test_set do |entry|
      case entry.basename.to_s
      when "LRS2" then process_lrs2(entry)
      else             not_supported(entry)
      end
    end
  end

  def process_lrs2(entry)
    single_language_process(entry) do |entry, _name, lang|
      [
        child_with_extension(entry, "#{lang}_videos.tar.gz"),
        child_with_extension(entry, "ref.#{lang}.tsv.sorted")
      ]
    end
  end
end
