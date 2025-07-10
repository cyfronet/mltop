class TestSetLoader::TtsProcessor < TestSetLoader::Processor
  def import!
    dir.each_child do |test_set|
      next if test_set.file?

      single_language_process(test_set) do |entry, _name, lang|
        [
          child_with_extension(entry, ".en_audios.tar.gz"),
          child_with_extension(entry, ".ref.en.tsv")
        ]
      end
    end
  end
end
