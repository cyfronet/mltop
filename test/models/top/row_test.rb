require "test_helper"

class Top::RowTest < ActiveSupport::TestCase
  test "returns only task models with results" do
    create(:model, name: "From other task", tasks: [ tasks(:asr) ])
    create(:model, name: "Without results", tasks: [ tasks(:st) ])
    model = create(:model, name: "Task model", tasks: [ tasks(:st), tasks(:asr) ])
    hypothesis = create(:hypothesis, model:)

    evaluation = create(:evaluation, hypothesis:,
                        evaluator: evaluators(:blueurt))
    create(:score, evaluation:, metric: metrics(:blueurt))

    rows = Top::Row.where(task: tasks(:st))

    assert_equal 1, rows.size, "Only task models with results should be returned"
    assert_equal model, rows.first.model, "Wrong task model"
    assert_equal model.name, rows.first.name, "Wrong model name"
  end

  test "calculate aggregated score for all subtasks" do
    model = create(:model, name: "Task model", tasks: [ tasks(:st) ])

    new_evaluation(model, :flores_st_en_pl, 3)
    row = Top::Row.where(task: tasks(:st)).first
    assert_equal 1, row.score(test_set: test_sets(:flores), metric: metrics(:blueurt)).value,
      "Wrong score: agreegated score is calcualted for all subtask, when missing 0 is used"

    new_evaluation(model, :flores_st_en_it, 1.5)
    row = Top::Row.where(task: tasks(:st)).first
    assert_equal 1.5, row.score(test_set: test_sets(:flores), metric: metrics(:blueurt)).value,
      "Wrong score: (2 (en->pl) + 1.5 (en->it) + 0 (pl->en)) / 3= 1.5"

    new_evaluation(model, :flores_st_pl_en, 4.5)
    row = Top::Row.where(task: tasks(:st)).first
    assert_equal 3, row.score(test_set: test_sets(:flores), metric: metrics(:blueurt)).value,
      "Wrong score: (2 (en->pl) + 1.5 (en->it) + 4.5 (pl->en)) / 3 = 3"
  end

  test "get model score" do
    model = create(:model, name: "Task model", tasks: [ tasks(:st) ])

    new_evaluation(model, :flores_st_en_pl, 1)

    row = Top::Row.where(task: tasks(:st)).first
    assert_equal 1, row.score(test_set: test_sets(:flores),
                              metric: metrics(:blueurt),
                              test_set_entry: test_set_entries(:flores_st_en_pl)).value

    assert_nil row.score(test_set: test_sets(:flores),
                         metric: metrics(:blueurt),
                         test_set_entry: test_set_entries(:flores_st_en_it)).value
              "Nil score should be created when no score in DB"
  end

  test "order" do
    m1 = create(:model, name: "model 1", tasks: [ tasks(:st) ])
    m2 = create(:model, name: "model 2", tasks: [ tasks(:st) ])
    m3 = create(:model, name: "model 3", tasks: [ tasks(:st) ])

    new_evaluation(m1, :flores_st_en_pl, 1)
    new_evaluation(m2, :flores_st_en_pl, 3)
    new_evaluation(m3, :flores_st_en_pl, 2)

    new_evaluation(m1, :flores_st_en_it, 20)
    new_evaluation(m2, :flores_st_en_it, 30)
    new_evaluation(m3, :flores_st_en_it, 10)

    rows = Top::Row.where(task: tasks(:st))

    # aggregated scores
    assert_equal [ m2, m1, m3 ], rows.order(test_set: test_sets(:flores),
                                            metric: metrics(:blueurt)).map(&:model)

    assert_equal [ m3, m1, m2 ], rows.order(test_set: test_sets(:flores),
                                            metric: metrics(:blueurt), order: :asc).map(&:model)

    # detailed, per test set entry
    assert_equal [ m2, m3, m1 ], rows.order(test_set: test_sets(:flores),
                                            metric: metrics(:blueurt),
                                            test_set_entry: test_set_entries(:flores_st_en_pl)).map(&:model)

    assert_equal [ m1, m3, m2 ], rows.order(test_set: test_sets(:flores),
                                            metric: metrics(:blueurt),
                                            test_set_entry: test_set_entries(:flores_st_en_pl), order: :asc).map(&:model)
  end

  test "order with metric asc order" do
    m1 = create(:model, name: "model 1", tasks: [ tasks(:st) ])
    m2 = create(:model, name: "model 2", tasks: [ tasks(:st) ])
    m3 = create(:model, name: "model 3", tasks: [ tasks(:st) ])

    new_evaluation(m1, :flores_st_en_pl, 1, evaluator: evaluators(:sacrebleu), metric: metrics(:ter))
    new_evaluation(m2, :flores_st_en_pl, 3, evaluator: evaluators(:sacrebleu), metric: metrics(:ter))
    new_evaluation(m3, :flores_st_en_pl, 2, evaluator: evaluators(:sacrebleu), metric: metrics(:ter))

    rows = Top::Row.where(task: tasks(:st))

    assert_equal [ m1, m3, m2 ], rows.order(test_set: test_sets(:flores),
                                            metric: metrics(:ter),
                                            test_set_entry: test_set_entries(:flores_st_en_pl)).map(&:model)

    assert_equal [ m2, m3, m1 ], rows.order(test_set: test_sets(:flores),
                                            metric: metrics(:ter),
                                            test_set_entry: test_set_entries(:flores_st_en_pl), order: :asc).map(&:model)
  end

  private
    def new_evaluation(model, test_set_entry_fixture_name, value, evaluator: evaluators(:blueurt), metric: metrics(:blueurt))
      hypothesis = create(:hypothesis, model:,
                          test_set_entry: test_set_entries(test_set_entry_fixture_name))
      evaluation = create(:evaluation, hypothesis:, evaluator:)
      create(:score, evaluation:, metric:, value:)
    end
end
