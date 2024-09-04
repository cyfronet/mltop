require "test_helper"

module Submissions
  class EvaluationsControllerTest < ActionDispatch::IntegrationTest
    include ActiveJob::TestHelper

    def setup
      sign_in_as("marek")
    end

    test "owner of the model can run evaluations" do
      model = create(:model)
      hypothesis = create(:hypothesis, model:)
      Hypothesis.any_instance.stubs(:evaluate!).returns(true)

      post hypothesis_evaluations_path(hypothesis_id: hypothesis, format: :turbo_stream)

      assert_response :success
      assert_equal "Evaluations queued to submit", flash[:notice]
    end

    test "owner of the model run evaluations with failure" do
      model = create(:model)
      hypothesis = create(:hypothesis, model:)
      Hypothesis.any_instance.stubs(:evaluate!).raises(ActiveRecord::RecordInvalid)

      post hypothesis_evaluations_path(hypothesis_id: hypothesis, format: :turbo_stream)

      assert_response :bad_request
      assert_equal "Unable to create evaluations", flash[:alert]
    end

    test "non-owner of the model cannot run evaluations" do
      model =  create(:model, owner: users("szymon"))
      hypothesis = create(:hypothesis, model:)
      hypothesis.stubs(:evaluate!).returns(:false)

      post hypothesis_evaluations_path(hypothesis_id: hypothesis, format: :turbo_stream)

      assert_response :not_found
    end
  end
end
