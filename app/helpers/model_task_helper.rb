module ModelTaskHelper
  def get_model_metric_on_given_test_set(model, metric, test_set)
    evaluation = model.evaluations.find_by(evaluator_id: metric.evaluator.id)
    metric_score = evaluation.scores.find_by(metric_id: metric.id).value
  end
end
