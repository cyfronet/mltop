require "test_helper"

class Challenges::Dashboard::Evaluators::MetricsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("marek")
    in_challenge!
  end

  test "should get new" do
    get new_dashboard_evaluator_metric_path(evaluators("sacrebleu"))
    assert_response :success
  end

  test "should create new metric" do
    evaluator = evaluators("sacrebleu")
    assert_difference("evaluator.metrics.count") do
      post dashboard_evaluator_metrics_path(evaluator, format: :turbo_stream), params: { metric: {
        name: "new-metric",
        order: "desc",
        worst_score: 20,
        best_score: 120
      } }
    end

    assert_response :success
  end

  test "should get edit" do
    metric = metrics(:blue)

    get edit_dashboard_metric_path(metric)
    assert_response :success
  end

  test "should update metric" do
    metric = metrics(:blue)

    patch dashboard_metric_path(metric), params: { metric: { name: "updated-name" } }
    assert_redirected_to dashboard_evaluator_path(metric.evaluator)
    assert_equal "updated-name", metric.reload.name
  end

  test "should destroy metric" do
    metric = metrics(:blue)

    assert_difference("Metric.count", -1) do
      delete dashboard_metric_path(metric)
    end

    assert_redirected_to dashboard_evaluator_path(metric.evaluator)
  end
end
