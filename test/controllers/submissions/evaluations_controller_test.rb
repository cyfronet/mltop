require "test_helper"

module Submissions
  class EvaluationsControllerTest < ActionDispatch::IntegrationTest
    include ActiveJob::TestHelper

    def setup
      in_challenge!
    end

    test "Meetween members can run owned model evaluations" do
      model = create(:model)
      hypothesis = create(:hypothesis, model:)
      Hypothesis.any_instance.stubs(:evaluate!)

      sign_in_as("marek")
      post hypothesis_evaluations_path(hypothesis_id: hypothesis, format: :turbo_stream)

      assert_response :success
      assert_equal "Evaluations queued to submit", flash[:notice]
    end

    test "Not Meetween member cannot start owned model evaluation" do
      model = create(:model, owner: users("external"))
      hypothesis = create(:hypothesis, model:)
      create(:evaluation, hypothesis:)

      sign_in_as("external", teams: [ "plgother" ])
      post hypothesis_evaluations_path(hypothesis_id: hypothesis, format: :turbo_stream)

      assert_response :forbidden
      assert_equal "Only Meetween members can perform this action", flash[:alert]
    end

    test "Meetween members cannot start other meetween user model evaluation" do
      model =  create(:model, owner: users("szymon"))
      hypothesis = create(:hypothesis, model:)

      sign_in_as("marek")
      post hypothesis_evaluations_path(hypothesis_id: hypothesis, format: :turbo_stream)

      assert_response :not_found
    end

    test "Meetween members can start external users model evaluations" do
      model =  create(:model, owner: users("external"))
      hypothesis = create(:hypothesis, model:)

      sign_in_as("marek")
      post hypothesis_evaluations_path(hypothesis_id: hypothesis, format: :turbo_stream)

      assert_response :success
      assert_equal "Evaluations queued to submit", flash[:notice]
    end
  end
end
