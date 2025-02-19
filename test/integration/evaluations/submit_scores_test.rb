require "test_helper"

class Evaluations::SubmitScoresTest < ActionDispatch::IntegrationTest
  def setup
    @evaluation = create(:evaluation, status: :running,
                         evaluator: evaluators(:sacrebleu))
  end

  test "can submit scores for running evaluation" do
    token = @evaluation.reset_token!

    post evaluation_scores_path(@evaluation),
      params: valid_scores,
      headers: headers(token)

    assert_response :success
  end

  test "cannot submit scores for not submitted evaluation" do
    token = @evaluation.reset_token!
    @evaluation.update(status: :created)

    post evaluation_scores_path(@evaluation),
      params: valid_scores,
      headers: headers(token)

    assert_response :unauthorized
  end

  test "cannot submit scores for finished evaluation" do
    token = @evaluation.reset_token!

    %i[ completed failed ].each do |status|
      @evaluation.update(status:)

      post evaluation_scores_path(@evaluation),
        params: valid_scores,
        headers: headers(token)

      assert_response :unauthorized
    end
  end

  test "all scores needs to be given" do
    token = @evaluation.reset_token!

    post evaluation_scores_path(@evaluation),
      params: invalid_scores,
      headers: headers(token)

    assert_response :unprocessable_entity
  end

  test "record error message when evaluation failed" do
    token = @evaluation.reset_token!

    post evaluation_scores_path(@evaluation),
      params: failed_evaluation,
      headers: headers(token)

    assert_response :success
    assert_equal "failed", @evaluation.reload.status
    assert_equal "Evaluation failed", @evaluation.reload.error_message
  end

  test "require valid token" do
    post evaluation_scores_path(@evaluation),
      params: valid_scores,
      headers: headers("invalid")

    assert_response :unauthorized
  end

  private
    def headers(token)
      authorization = ActionController::HttpAuthentication::Token.encode_credentials(token)

      { "Authorization" => authorization, "ContentType" => "application/json" }
    end

    def valid_scores   = { state: "OK", scores: { blue: 1, chrf: 2, ter: 3.3 } }
    def invalid_scores = { state: "OK", scores: { blue: 1, chrf: 2 } }
    def failed_evaluation = { state: "ERROR", message: "Evaluation failed" }
end
