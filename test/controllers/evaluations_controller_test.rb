require "test_helper"

class EvaluationsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper
  test "Challenge manager can run owned model evaluations" do
    model = create(:model, owner: users("marek"))
    hypothesis = create(:hypothesis, model:)

    sign_in_as("marek")
    in_challenge!(users(:marek))

    post evaluations_path(format: :turbo_stream), params: {
      evaluation: {
        hypothesis_id: hypothesis.id,
        evaluator_id: evaluators("sacrebleu").id
      }
    }

    assert_response :success
    assert_equal "Evaluation queued to submit", flash[:notice]
  end

  test "Challenge participants cannot start owned model evaluation" do
    model = create(:model, owner: users("external"))
    hypothesis = create(:hypothesis, model:)

    sign_in_as("external", teams: [ "plgggemini" ])
    in_challenge!(users(:external))

    post evaluations_path(format: :turbo_stream), params: {
      evaluation: {
        hypothesis_id: hypothesis.id,
        evaluator_id: evaluators("sacrebleu").id
      }
    }

    assert_response :redirect
    assert_equal "You are not authorized to perform this action", flash[:alert]
  end

  test "Managers cannot start other managers model evaluation" do
    model =  create(:model, owner: users(:szymon))
    users(:szymon).update(groups: [ "plggmeetween" ])
    create(:membership, user: users(:szymon), challenge: challenges(:global))
    hypothesis = create(:hypothesis, model:)

    sign_in_as(:marek)
    in_challenge!(users(:marek), :manager)
    post evaluations_path(format: :turbo_stream), params: {
      evaluation: {
        hypothesis_id: hypothesis.id,
        evaluator_id: evaluators("sacrebleu").id
      }
    }

    assert_response :not_found
  end

  test "Challenge managers can start external users model evaluations" do
    model =  create(:model, owner: users("external"))
    hypothesis = create(:hypothesis, model:)

    sign_in_as(:marek)
    in_challenge!(users(:marek), :manager)
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
