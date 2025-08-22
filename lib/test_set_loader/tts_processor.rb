class TestSetLoader::TtsProcessor < TestSetLoader::Processor
  def import!
    for_each_test_set do |dir|
      single_language_process(dir) do |entry, _name, lang|
        [
          child_with_extension(entry, ".src.#{lang}.tsv"),
          child_with_extension(entry, ".ref.#{lang}.tsv")
        ]
      end
    end
  end
end
