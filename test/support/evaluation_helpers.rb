# frozen_string_literal: true

module EvaluationHelpers
  def new_evaluation(model, test_set_entry_fixture_name, value, evaluator: evaluators(:blueurt), metric: metrics(:blueurt))
    hypothesis = create(:hypothesis, model:,
                        test_set_entry: test_set_entries(test_set_entry_fixture_name))
    evaluation = create(:evaluation, hypothesis:, evaluator:)
    create(:score, evaluation:, metric:, value:)
  end
end
