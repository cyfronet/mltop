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

    # en_it_model has the better average (2/4 vs 1/4), so it is moved to the top
    assert_equal [ en_it_model, en_pl_model ], tables.first.rows.map(&:model)
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

  test "top row is moved to the top by default" do
    m1, m2, m3 = create_list(:model, 3, tasks: [ tasks(:st) ])

    new_evaluation(m1, :flores_st_en_pl, 1)
    new_evaluation(m2, :flores_st_en_pl, 2)
    new_evaluation(m3, :flores_st_en_pl, 5) # best, but created last

    table = entry_table(Top::Row.where(task: tasks(:st)))

    assert_equal m3, table.rows.first.model, "Best row should be first"
    assert table.top_row?(table.rows.first)
    assert_equal [ m1, m2 ], table.rows.drop(1).map(&:model).sort_by(&:id),
      "Remaining rows should still be present"
  end

  test "tied top rows are all moved to the top" do
    m1, m2, m3 = create_list(:model, 3, tasks: [ tasks(:st) ])

    new_evaluation(m1, :flores_st_en_pl, 1)
    new_evaluation(m2, :flores_st_en_pl, 5)
    new_evaluation(m3, :flores_st_en_pl, 5)

    table = entry_table(Top::Row.where(task: tasks(:st)))

    assert_equal [ m2, m3 ].map(&:id).sort, table.rows.first(2).map { |r| r.model.id }.sort
    assert_equal m1, table.rows.last.model
  end

  test "top row respects metrics preferring lower scores" do
    m1, m2, m3 = create_list(:model, 3, tasks: [ tasks(:st) ])

    new_evaluation(m1, :flores_st_en_pl, 3, evaluator: evaluators(:sacrebleu), metric: metrics(:ter))
    new_evaluation(m2, :flores_st_en_pl, 2, evaluator: evaluators(:sacrebleu), metric: metrics(:ter))
    new_evaluation(m3, :flores_st_en_pl, 1, evaluator: evaluators(:sacrebleu), metric: metrics(:ter))

    table = entry_table(Top::Row.where(task: tasks(:st)), metrics: [ metrics(:ter) ])

    assert_equal m3, table.rows.first.model, "Lowest TER is the best score"
  end

  test "explicit order is preserved and top rows are not moved" do
    m1, m2, m3 = create_list(:model, 3, tasks: [ tasks(:st) ])

    new_evaluation(m1, :flores_st_en_pl, 1)
    new_evaluation(m2, :flores_st_en_pl, 2)
    new_evaluation(m3, :flores_st_en_pl, 5)

    rows = Top::Row.where(task: tasks(:st))
      .order(test_set: test_sets(:flores), metric: metrics(:blueurt), order: "asc")
    table = entry_table(rows)

    assert_equal [ m1, m2, m3 ], table.rows.map(&:model), "Explicit ascending order must be kept (best row last)"

    rows = Top::Row.where(task: tasks(:st))
      .order(test_set: test_sets(:flores), metric: metrics(:blueurt), order: "desc")

    assert_equal [ m3, m2, m1 ], entry_table(rows).rows.map(&:model)
  end

  test "top rows are moved to the top when order is called without test set and metric" do
    m1, m2 = create_list(:model, 2, tasks: [ tasks(:st) ])

    new_evaluation(m1, :flores_st_en_pl, 1)
    new_evaluation(m2, :flores_st_en_pl, 5)

    rows = Top::Row.where(task: tasks(:st)).order(test_set: nil, metric: nil)

    assert_equal m2, entry_table(rows).rows.first.model
  end

  test "rows are ordered by number of winning metrics" do
    loser, wins_blueurt, wins_ter = create_list(:model, 3, tasks: [ tasks(:st) ])

    # blueurt on en->pl: higher is better
    new_evaluation(loser, :flores_st_en_pl, 1)
    new_evaluation(wins_blueurt, :flores_st_en_pl, 5)
    new_evaluation(wins_ter, :flores_st_en_pl, 3)

    # ter on en->it: lower is better
    new_evaluation(loser, :flores_st_en_it, 9, evaluator: evaluators(:sacrebleu), metric: metrics(:ter))
    new_evaluation(wins_blueurt, :flores_st_en_it, 5, evaluator: evaluators(:sacrebleu), metric: metrics(:ter))
    new_evaluation(wins_ter, :flores_st_en_it, 1, evaluator: evaluators(:sacrebleu), metric: metrics(:ter))

    table = average_table(Top::Row.where(task: tasks(:st)), metrics: [ metrics(:blueurt), metrics(:ter) ])
    models = table.rows.map(&:model)

    assert_equal [ wins_blueurt, wins_ter ].map(&:id).sort, models.first(2).map(&:id).sort,
      "Rows with one win each should come before the row with none"
    assert_equal loser, models.last, "Row without wins should be last"
  end

  test "row with the most wins comes first, then rows with fewer wins" do
    none, one, two = create_list(:model, 3, tasks: [ tasks(:st) ])

    # blueurt (higher is better): two wins
    new_evaluation(none, :flores_st_en_pl, 1)
    new_evaluation(one, :flores_st_en_pl, 3)
    new_evaluation(two, :flores_st_en_pl, 5)

    # ter (lower is better): two and one tie for the best score
    new_evaluation(none, :flores_st_en_it, 9, evaluator: evaluators(:sacrebleu), metric: metrics(:ter))
    new_evaluation(one, :flores_st_en_it, 1, evaluator: evaluators(:sacrebleu), metric: metrics(:ter))
    new_evaluation(two, :flores_st_en_it, 1, evaluator: evaluators(:sacrebleu), metric: metrics(:ter))

    table = average_table(Top::Row.where(task: tasks(:st)), metrics: [ metrics(:blueurt), metrics(:ter) ])

    # two: 2 wins, one: 1 win (ter tie), none: 0 wins
    assert_equal [ two, one, none ], table.rows.map(&:model)
    assert_equal [ two ], table.rows.select { |r| table.top_row?(r) }.map(&:model)
  end

  private
    def table_for(tables, test_set_entry_fixture_name)
      tables.find { |table| table.test_set_entry == test_set_entries(test_set_entry_fixture_name) }
    end

    def average_table(rows, metrics: [ metrics(:blueurt) ])
      Top::Table.new(title: "Average", rows:, test_set: test_sets(:flores), metrics:)
    end

    def entry_table(rows, metrics: [ metrics(:blueurt) ])
      Top::Table.new(
        title: "en->pl",
        rows:,
        test_set: test_sets(:flores),
        metrics:,
        test_set_entry: test_set_entries(:flores_st_en_pl)
      )
    end
end
