require "test_helper"

class TestSetTest < ActiveSupport::TestCase
  test "returns all entries languages for task" do
    test_set = test_sets("flores")
    task = tasks("st")

    assert_equal [ "en", "pl" ].sort, test_set.source_languages_for(task:).sort
    assert_equal [ "en", "pl", "it" ].sort, test_set.target_languages_for(task:).sort
  end

  test "get test set entry by language" do
    test_set = test_sets("flores")
    task = tasks("st")

    assert_nil test_set.entry_language_for(source: "en", target: "de", task:), "Should return nil on non existing subtask test set"
    assert_equal test_set_entries("flores_st_en_pl"), test_set.entry_language_for(source: "en", target: "pl", task:)
    assert_equal test_set_entries("flores_st_pl_en"), test_set.entry_language_for(source: "pl", target: "en", task:)
  end

  test "filter entries by task" do
    st = tasks("st")
    flores = test_sets("flores")

    entries = flores.entries.for_task(st)

    assert_equal 3, entries.size
    assert_equal test_set_entries("flores_st_en_pl", "flores_st_en_it", "flores_st_pl_en"), entries
  end

  test "get all published test sets" do
    published = TestSet.published

    assert_equal test_sets(:flores, :mustc).sort, published
  end
end
