require "test_helper"

class Model::ScoresTest < ActiveSupport::TestCase
  test "model scores for selected metric, test set and task" do
    other_model = create(:model, name: "Other task", tasks: [ tasks(:st) ])
    model = create(:model, name: "Model", tasks: [ tasks(:st), tasks(:asr) ])
    hypothesis_pl = create(:hypothesis, model:, test_set_entry: test_set_entries("flores_st_en_pl"))
    hypothesis_it = create(:hypothesis, model:, test_set_entry: test_set_entries("flores_st_en_it"))
    other_hypothesis = create(:hypothesis, model: other_model)
    asr_test_entry = create(:test_set_entry, task: tasks(:asr), test_set: test_sets(:flores), source_language: "be", target_language: "bg")
    asr_hypothesis = create(:hypothesis, model:, test_set_entry: asr_test_entry)

    evaluation = create(:evaluation, hypothesis: hypothesis_pl,
                        evaluator: evaluators(:sacrebleu))
    create(:score, evaluation:, metric: metrics("blue"), value: 1)
    create(:score, evaluation:, metric: metrics("chrf"), value: 2)

    evaluation = create(:evaluation, hypothesis: hypothesis_it,
                        evaluator: evaluators(:sacrebleu))
    create(:score, evaluation:, metric: metrics("blue"), value: 3)
    create(:score, evaluation:, metric: metrics("chrf"), value: 4)

    evaluation = create(:evaluation, hypothesis: other_hypothesis,
                        evaluator: evaluators(:sacrebleu))
    create(:score, evaluation:, metric: metrics("blue"), value: 5)
    create(:score, evaluation:, metric: metrics("chrf"), value: 6)

    evaluation = create(:evaluation, hypothesis: asr_hypothesis,
    evaluator: evaluators(:sacrebleu))
    create(:score, evaluation:, metric: metrics("blue"), value: 5)
    create(:score, evaluation:, metric: metrics("chrf"), value: 6)

    scores = Model::Scores.new(model:, task: tasks("st"), test_set: test_sets("flores"), metric: metrics("blue"))
    assert_nil scores.score("en", "pt"), "Nil should be returned for non existing score"
    assert_equal 1, scores.score("en", "pl")
    assert_equal 3, scores.score("en", "it")
    assert_nil scores.score("be", "bg"), "Nil is returned for non existing score within the task"

    scores = Model::Scores.new(model:, task: tasks("st"), test_set: test_sets("flores"), metric: metrics("chrf"))
    assert_nil scores.score("en", "pt"), "Nil should be returned for non existing score"
    assert_equal 2, scores.score("en", "pl")
    assert_equal 4, scores.score("en", "it")
    assert_nil scores.score("be", "bg"), "Nil is returned for non existing score within the task"
  end
end
