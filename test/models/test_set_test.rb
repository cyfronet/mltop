require "test_helper"

class TestSetTest < ActiveSupport::TestCase
  test "returns all subtasks source languages" do
    test_set = test_sets("flores")

    assert_equal [ "en" ], test_set.source_languages
  end

  test "returns all subtasks target languages" do
    test_set = test_sets("flores")

    assert_equal 2, test_set.target_languages.size
    assert_includes test_set.target_languages, "pl"
    assert_includes test_set.target_languages, "it"
  end

  test "get subtask test set by source and target languages" do
    test_set = test_sets("flores")

    assert_nil test_set.for_subtask("pl", "en"), "Should return nil on non existing subtask test set"
    assert_equal subtask_test_sets("flores_en_pl"), test_set.for_subtask("en", "pl")
    assert_equal subtask_test_sets("flores_en_it"), test_set.for_subtask("en", "it")
  end

  test "all subtasks inputs" do
    flores = test_sets("flores")

    file_names = []
    Zip::File.open(flores.all_inputs_zip_path) do |zip_file|
      zip_file.each { |entry| file_names << entry.name }
    end

    assert_equal 2, file_names.size, "We should have each file for subtask"
    assert_equal [ "FLORES--en-to-pl.txt", "FLORES--en-to-it.txt" ].sort, file_names.sort
  end
end
