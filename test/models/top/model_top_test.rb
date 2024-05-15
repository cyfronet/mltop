require "test_helper"

class Top::RowTest < ActiveSupport::TestCase
  test "model scores for selected metric and test set" do
    create(:model, name: "Other task", tasks: [ tasks(:st) ])
    model = create(:model, name: "Model", tasks: [ tasks(:st) ])

    evaluation = create(:evaluation, model:,
                        evaluator: evaluators(:sacrebley),
                        subtask_test_set: subtask_test_sets(:flores_en_pl))
    create(:score, evaluation:, metric: metrics("blue"), value: 1)
    create(:score, evaluation:, metric: metrics("chrf"), value: 2)

    evaluation = create(:evaluation, model:,
                        evaluator: evaluators(:sacrebley),
                        subtask_test_set: subtask_test_sets(:flores_en_it))
    create(:score, evaluation:, metric: metrics("blue"), value: 3)
    create(:score, evaluation:, metric: metrics("chrf"), value: 4)

    scores = Top::ModelRow.new(model:, test_set: test_sets("flores"), metric: metrics("blue"))
    assert_nil scores.score("en", "pt"), "Nil should be returned for non existing score"
    assert_equal 1, scores.score("en", "pl")
    assert_equal 3, scores.score("en", "it")

    scores = Top::ModelRow.new(model:, test_set: test_sets("flores"), metric: metrics("chrf"))
    assert_nil scores.score("en", "pt"), "Nil should be returned for non existing score"
    assert_equal 2, scores.score("en", "pl")
    assert_equal 4, scores.score("en", "it")
  end
end
