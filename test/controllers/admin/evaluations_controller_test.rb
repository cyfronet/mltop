require "test_helper"

class Admin::EvaluatorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("marek")
  end

  test "should get index" do
    get admin_evaluators_path
    assert_response :success
  end

  test "should get new" do
    get new_admin_evaluator_path
    assert_response :success
  end

  test "should create new evaluator" do
    assert_difference("Evaluator.count") do
      post admin_evaluators_url, params: { evaluator: {
        name: "New evaluator name", script: "dummy script", host: "dummy host"
      } }
    end

    assert_redirected_to admin_evaluator_path(Evaluator.last)
  end

  test "should show evaluator" do
    evaluator = evaluators(:sacrebleu)

    get admin_evaluator_path(evaluator)
    assert_response :success
  end

  test "should get edit" do
    evaluator = evaluators(:sacrebleu)

    get edit_admin_evaluator_path(evaluator)
    assert_response :success
  end

  test "should update evaluator" do
    evaluator = evaluators(:sacrebleu)

    patch admin_evaluator_path(evaluator), params: { evaluator: { name: "updated name" } }
    assert_redirected_to admin_evaluator_path(evaluator)
    assert_equal "updated name", evaluator.reload.name
  end

  test "should destroy evaluator" do
    evaluator = evaluators(:sacrebleu)

    assert_difference("Evaluator.count", -1) do
      delete admin_evaluator_path(evaluator)
    end

    assert_redirected_to admin_evaluators_path
  end
end
