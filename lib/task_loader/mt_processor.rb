class TaskLoader::MtProcessor < TaskLoader::Processor
  def import!
    dir.each_child do |test_set|
      next if test_set.file?

      from_to_language_process(test_set) do |entry, _name, source, target|
        [
          child_with_extension(entry, ".#{source}"),
          child_with_extension(entry, ".#{target}")
        ]
      end
    end
  end
end
