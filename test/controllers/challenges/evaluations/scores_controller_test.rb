require "test_helper"
module Challenges
  module Evaluations
    class ScoresControllerTest < ActionDispatch::IntegrationTest
      setup do
        sign_in_as("marek")
        in_challenge!
        @evaluation = create(:evaluation, status: :pending)
        @evaluation.reset_token!
      end

      test "returns 201 when scores are submitted successfully with OK state" do
        post evaluation_scores_path(@evaluation),
          params: { state: "OK", scores: { blueurt: 0.9 } },
          headers: { "Authorization" => "Bearer #{@evaluation.token}" },
          as: :json

        assert_response :created
      end

      test "returns 400 when scores param is missing" do
        post evaluation_scores_path(@evaluation),
          params: { state: "OK" },
          headers: { "Authorization" => "Bearer #{@evaluation.token}" },
          as: :json

        assert_response :bad_request
        json = JSON.parse(response.body)
        assert_includes json["message"], "scores"
      end

      test "returns 201 when state is not OK and message is provided" do
        post evaluation_scores_path(@evaluation),
          params: { state: "ERROR", message: "something went wrong" },
          headers: { "Authorization" => "Bearer #{@evaluation.token}" },
          as: :json

        assert_response :created
      end

      test "returns 422 when scores are invalid" do
        post evaluation_scores_path(@evaluation),
          params: { state: "OK", scores: { blueurt: 500 } },
          headers: { "Authorization" => "Bearer #{@evaluation.token}" },
          as: :json

        assert_response :unprocessable_entity
        json = JSON.parse(response.body)
        assert json["message"].present?
      end

      test "returns 400 when body is invalid json" do
        post evaluation_scores_path(@evaluation),
          headers: { "Authorization" => "Bearer #{@evaluation.token}",
                    "Content-Type" => "application/json"
          },
          params: "{ 'invalid json' }"

        assert_response :bad_request
        json = JSON.parse(response.body)
        assert json["message"].present?
      end
    end
  end
end
