class TestSetMetadata
  def initialize(tasks_yml_path, test_sets_yml_path)
    @tasks = YAML.load_file(tasks_yml_path)
    @test_sets = YAML.load_file(test_sets_yml_path)
  end

  def skip?(task_slug, test_set_slug, from_to = nil)
    entries_langs = @tasks.dig(task_slug, "test_sets", test_set_slug) || []

    entries_langs.blank? || from_to && !entries_langs.include?(from_to)
  end

  def description(task_slug)
    @test_sets.dig(task_slug, "description")
  end
end
