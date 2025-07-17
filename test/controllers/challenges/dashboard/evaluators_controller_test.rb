require "test_helper"

class Challenges::Dashboard::EvaluatorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("marek")
    in_challenge!
  end

  test "should get index" do
    get dashboard_evaluators_path
    assert_response :success
  end

  test "should get new" do
    get new_dashboard_evaluator_path
    assert_response :success
  end

  test "should create new evaluator" do
    Current.challenge = challenges(:global)

    assert_difference("Evaluator.count") do
      post dashboard_evaluators_url, params: { evaluator: {
        name: "New evaluator name", script: "dummy script", host: "dummy host"
      } }
    end

    assert_redirected_to dashboard_evaluator_path(Evaluator.last)
  end

  test "should show evaluator" do
    evaluator = evaluators(:sacrebleu)

    get dashboard_evaluator_path(evaluator)
    assert_response :success
  end

  test "should get edit" do
    evaluator = evaluators(:sacrebleu)

    get edit_dashboard_evaluator_path(evaluator)
    assert_response :success
  end

  test "should update evaluator" do
    evaluator = evaluators(:sacrebleu)

    patch dashboard_evaluator_path(evaluator), params: { evaluator: { name: "updated name" } }
    assert_redirected_to dashboard_evaluator_path(evaluator)
    assert_equal "updated name", evaluator.reload.name
  end

  test "should destroy evaluator" do
    evaluator = evaluators(:sacrebleu)

    assert_difference("Evaluator.count", -1) do
      delete dashboard_evaluator_path(evaluator)
    end

    assert_redirected_to dashboard_evaluators_path
  end
end
