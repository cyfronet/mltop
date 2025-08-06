require "test_helper"

class Top::RowTest < ActiveSupport::TestCase
  include EvaluationHelpers

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

    new_evaluation(model, :flores_st_en_pl, 4)
    row = Top::Row.where(task: tasks(:st)).first
    assert_equal 1, row.score(test_set: test_sets(:flores), metric: metrics(:blueurt)).value,
      "Wrong score: agreegated score is calcualted for all subtask, when missing 0 is used"

    new_evaluation(model, :flores_st_en_it, 2)
    row = Top::Row.where(task: tasks(:st)).first
    assert_equal 1.5, row.score(test_set: test_sets(:flores), metric: metrics(:blueurt)).value,
      "Wrong score: (4 (en->pl) + 2 (en->it) + 0 (pl->en) + 0 (en->de)) / 4= 1.5"

    new_evaluation(model, :flores_st_pl_en, 4)
    row = Top::Row.where(task: tasks(:st)).first
    assert_equal 2.5, row.score(test_set: test_sets(:flores), metric: metrics(:blueurt)).value,
      "Wrong score: (4 (en->pl) + 2 (en->it) + 4 (pl->en) + 0 (en->de)) / 4 = 2.5"
  end

  test "filters and calculates aggregated score for specific source and target" do
    model = create(:model, name: "Task model", tasks: [ tasks(:st) ])

    new_evaluation(model, :flores_st_en_pl, 4)
    row = Top::Row.where(task: tasks(:st)).first
    assert_equal 1, row.score(test_set: test_sets(:flores), metric: metrics(:blueurt)).value,
      "Wrong score: agreegated score is calcualted for all subtask, when missing 0 is used"

    new_evaluation(model, :flores_st_en_it, 2)
    row = Top::Row.where(task: tasks(:st), source: "en").first
    assert_equal 2, row.score(test_set: test_sets(:flores), metric: metrics(:blueurt)).value,
      "Wrong score: (4 (en->pl) + 2 (en->it) + 0 (en->de)) / 3 = 2"

    new_evaluation(model, :flores_st_pl_en, 4.5)
    row = Top::Row.where(task: tasks(:st), source: "en").first
    assert_equal 2, row.score(test_set: test_sets(:flores), metric: metrics(:blueurt)).value,
  "Wrong score: (4 (en->pl) + 2 (en->it) + 0 (en->de)) / 3 = 2, pl->en not included"

    new_evaluation(model, :flores_st_en_de, 6)
    row = Top::Row.where(task: tasks(:st), source: "en").first
    assert_equal 4, row.score(test_set: test_sets(:flores), metric: metrics(:blueurt)).value,
      "Wrong score: (4 (en->pl) + 2 (en->it) + 6 (en->de)) / 3 = 4"

    row = Top::Row.where(task: tasks(:st), source: "en", target: "de").first
    assert_equal 6, row.score(test_set: test_sets(:flores), metric: metrics(:blueurt)).value,
      "Wrong score: 6 (en->de) / 1 = 6"
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

  test "source and target languages for empty result" do
    assert_equal [], Top::Row.none.source_languages
    assert_equal [], Top::Row.none.target_languages
  end

  test "source and target languages for task" do
    rows = Top::Row.where(task: tasks(:st))

    assert_equal %w[en pl], rows.source_languages.sort
    assert_equal %w[de en it pl], rows.target_languages.sort
  end

  test "source and target languages for task and test set" do
    rows = Top::Row.where(task: tasks(:st), test_set: test_sets("mustc"))

    assert_equal %w[en pl], rows.source_languages.sort
    assert_equal %w[en pl], rows.target_languages.sort
  end

  test "by default use absolute normalization" do
    model = create(:model, name: "Task model", tasks: [ tasks(:st) ])

    new_evaluation(model, :flores_st_en_pl, 100)
    row = Top::Row.where(task: tasks(:st)).first
    score = row.score(test_set: test_sets(:flores), metric: metrics(:blueurt))

    assert_equal 0.25, score.normalized

    new_evaluation(model, :flores_st_en_it, 60)
    row = Top::Row.where(task: tasks(:st)).first
    score = row.score(test_set: test_sets(:flores), metric: metrics(:blueurt))

    assert_equal 0.4, score.normalized
  end

  test "relative normalization" do
    m1, m2, m3 = create_list(:model, 3, tasks: [ tasks(:st) ])

    new_evaluation(m1, :flores_st_en_pl, 100, metric: metrics(:blueurt))
    new_evaluation(m2, :flores_st_en_pl, 50, metric: metrics(:blueurt))
    new_evaluation(m3, :flores_st_en_pl, 75, metric: metrics(:blueurt))
    rows = Top::Row.where(task: tasks(:st)).order(test_set: test_sets(:flores), metric: metrics(:blueurt))
    rows.relative!

    row = rows.second
    score = row.score(test_set: test_sets(:flores), metric: metrics(:blueurt), test_set_entry: test_set_entries(:flores_st_en_pl))

    assert_equal m3, row.model
    assert_equal 0.5, score.normalized
  end
end
