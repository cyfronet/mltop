require "test_helper"

class Evaluations::SubmitMetricsTest < ActionDispatch::IntegrationTest
  def setup
    @evaluation = create(:evaluation, evaluator: evaluators(:sacrebleu))
  end

  test "can submit metrics for running evaluation" do
    token = @evaluation.reset_token!

    post evaluation_metrics_path(@evaluation),
      params: valid_scores,
      headers: headers(token)

    assert_response :success
  end

  test "all metrics needs to be given" do
    token = @evaluation.reset_token!

    post evaluation_metrics_path(@evaluation),
      params: invalid_scores,
      headers: headers(token)

    assert_response :unprocessable_entity
  end

  test "require valid token" do
    post evaluation_metrics_path(@evaluation),
      params: valid_scores,
      headers: headers("invalid")

    assert_response :unauthorized
  end

  private
    def headers(token)
      authorization = ActionController::HttpAuthentication::Token.encode_credentials(token)

      { "Authorization" => authorization, "ContentType" => "application/json" }
    end

    def valid_scores   = { scores: { blue: 1, chrf: 2, ter: 3.3 } }
    def invalid_scores = { scores: { blue: 1, chrf: 2 } }
end
