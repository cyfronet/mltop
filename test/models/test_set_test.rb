require "test_helper"

class TestSetTest < ActiveSupport::TestCase
  test "returns all entries languages" do
    test_set = test_sets("flores")

    assert_equal [ "en", "pl" ].sort, test_set.source_languages.sort
    assert_equal [ "en", "pl", "it" ].sort, test_set.target_languages.sort
  end

  test "get test set entry by language" do
    test_set = test_sets("flores")

    assert_nil test_set.entry_for_language("en", "de"), "Should return nil on non existing subtask test set"
    assert_equal test_set_entries("flores_st_en_pl"), test_set.entry_for_language("en", "pl")
    assert_equal test_set_entries("flores_st_pl_en"), test_set.entry_for_language("pl", "en")
  end

  test "all subtasks inputs" do
    flores = test_sets("flores")

    file_names = []
    Zip::File.open(flores.all_inputs_zip_path(tasks("st"))) do |zip_file|
      zip_file.each { |entry| file_names << entry.name }
    end

    assert_equal 3, file_names.size, "We should have each file for entry"
    assert_equal [ "FLORES--en-pl.txt", "FLORES--en-it.txt", "FLORES--pl-en.txt" ].sort, file_names.sort
  end

  test "filter entries by task" do
    st = tasks("st")
    flores = test_sets("flores")

    entries = flores.entries.for_task(st)

    assert_equal 3, entries.size
    assert_equal test_set_entries("flores_st_en_pl", "flores_st_en_it", "flores_st_pl_en"), entries
  end
end
