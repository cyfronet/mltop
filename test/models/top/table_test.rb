# frozen_string_literal: true

require "test_helper"

class Top::TableTest < ActiveSupport::TestCase
  include EvaluationHelpers

  test "test set tables keep only rows with scores for that table" do
    en_pl_model = create(:model, name: "en-pl model", tasks: [ tasks(:st) ])
    en_it_model = create(:model, name: "en-it model", tasks: [ tasks(:st) ])

    new_evaluation(en_pl_model, :flores_st_en_pl, 1)
    new_evaluation(en_it_model, :flores_st_en_it, 2)

    rows = Top::Row.where(task: tasks(:st), test_set: test_sets(:flores))
    tables = Top::Table.for_test_set(
      rows:,
      test_set: test_sets(:flores),
      test_set_entries: test_sets(:flores).entries.for_task(tasks(:st)),
      metrics: [ metrics(:blueurt) ]
    )

    assert_equal [ en_pl_model, en_it_model ], tables.first.rows.map(&:model)
    assert_equal [ en_pl_model ], table_for(tables, :flores_st_en_pl).rows.map(&:model)
    assert_equal [ en_it_model ], table_for(tables, :flores_st_en_it).rows.map(&:model)
    assert_nil table_for(tables, :flores_st_en_de)
  end

  test "task tables keep only rows with scores for that test set" do
    flores_model = create(:model, name: "flores model", tasks: [ tasks(:st) ])
    mustc_model = create(:model, name: "mustc model", tasks: [ tasks(:st) ])

    new_evaluation(flores_model, :flores_st_en_pl, 1)
    new_evaluation(mustc_model, :mustc_st_en_pl, 2)

    rows = Top::Row.where(task: tasks(:st))
    tables = Top::Table.for_task(rows:, test_sets: [ test_sets(:flores), test_sets(:mustc) ], metrics: [ metrics(:blueurt) ])

    assert_equal [ flores_model ], tables.find { |table| table.test_set == test_sets(:flores) }.rows.map(&:model)
    assert_equal [ mustc_model ], tables.find { |table| table.test_set == test_sets(:mustc) }.rows.map(&:model)
  end

  private
    def table_for(tables, test_set_entry_fixture_name)
      tables.find { |table| table.test_set_entry == test_set_entries(test_set_entry_fixture_name) }
    end
end
