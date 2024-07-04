require "test_helper"

class TestSetTest < ActiveSupport::TestCase
  test "returns all entries languages" do
    test_set = test_sets("flores")

    assert_equal [ "en", "pl" ].sort, test_set.languages.sort
  end

  test "get test set entry by language" do
    test_set = test_sets("flores")

    assert_nil test_set.entry_for_language("de"), "Should return nil on non existing subtask test set"
    assert_equal test_set_entries("flores_en"), test_set.entry_for_language("en")
    assert_equal test_set_entries("flores_pl"), test_set.entry_for_language("pl")
  end

  test "all subtasks inputs" do
    flores = test_sets("flores")

    file_names = []
    Zip::File.open(flores.all_inputs_zip_path) do |zip_file|
      zip_file.each { |entry| file_names << entry.name }
    end

    assert_equal 2, file_names.size, "We should have each file for language"
    assert_equal [ "FLORES--en.txt", "FLORES--pl.txt" ].sort, file_names.sort
  end
end
