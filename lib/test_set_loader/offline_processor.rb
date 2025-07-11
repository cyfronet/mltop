class TestSetLoader::OfflineProcessor < TestSetLoader::Processor
  def import!
    for_each_test_set do |test_set|
      from_to_language_process(test_set) do |entry, _name, source, target|
        [
          child_with_extension(entry, ".#{source}"),
          child_with_extension(entry, ".#{target}")
        ]
      end
    end
  end
end
