require "test_helper"

class EvaluationsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  def setup
    in_challenge!
  end

  test "Meetween members can run owned model evaluations" do
    model = create(:model, owner: users("marek"))
    hypothesis = create(:hypothesis, model:)

    sign_in_as("marek")
    post evaluations_path(format: :turbo_stream), params: {
      evaluation: {
        hypothesis_id: hypothesis.id,
        evaluator_id: evaluators("sacrebleu").id
      }
    }

    assert_response :success
    assert_equal "Evaluation queued to submit", flash[:notice]
  end

  test "Not Meetween member cannot start owned model evaluation" do
    model = create(:model, owner: users("external"))
    hypothesis = create(:hypothesis, model:)

    sign_in_as("external", teams: [ "plgother" ])
    post evaluations_path(format: :turbo_stream), params: {
      evaluation: {
        hypothesis_id: hypothesis.id,
        evaluator_id: evaluators("sacrebleu").id
      }
    }

    assert_response :forbidden
    assert_equal "Only Meetween members can perform this action", flash[:alert]
  end

  test "Meetween members cannot start other meetween user model evaluation" do
    model =  create(:model, owner: users("szymon"))
    hypothesis = create(:hypothesis, model:)

    sign_in_as("marek")
    post evaluations_path(format: :turbo_stream), params: {
      evaluation: {
        hypothesis_id: hypothesis.id,
        evaluator_id: evaluators("sacrebleu").id
      }
    }

    assert_response :not_found
  end

  test "Meetween members can start external users model evaluations" do
    model =  create(:model, owner: users("external"))
    hypothesis = create(:hypothesis, model:)

    sign_in_as("marek")
    post evaluations_path(format: :turbo_stream), params: {
      evaluation: {
        hypothesis_id: hypothesis.id,
        evaluator_id: evaluators("sacrebleu").id
      }
    }

    assert_response :success
    assert_equal "Evaluation queued to submit", flash[:notice]
  end
end
