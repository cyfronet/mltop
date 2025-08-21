require "test_helper"

module Challenges
  module Submissions
    class EvaluationsControllerTest < ActionDispatch::IntegrationTest
      include ActiveJob::TestHelper

      def setup
      end

      test "Challenge managers can run owned model evaluations" do
        model = create(:model)
        hypothesis = create(:hypothesis, model:)
        Hypothesis.any_instance.stubs(:evaluate!)

        challenge_member_signs_in("marek", challenges(:global), teams: [ "plggmeetween" ])
        post hypothesis_evaluations_path(hypothesis_id: hypothesis, format: :turbo_stream)

        assert_response :success
        assert_equal "Evaluations queued to submit", flash[:notice]
      end

      test "Participant cannot start owned model evaluation" do
        model = create(:model, owner: users("external"))
        hypothesis = create(:hypothesis, model:)
        create(:evaluation, hypothesis:)
        challenges(:global).access_rules.required.update_all(required: false)

        challenge_member_signs_in("external", challenges(:global), teams: [ "plggother" ])
        post hypothesis_evaluations_path(hypothesis_id: hypothesis, format: :turbo_stream)

        assert_response :redirect
        assert_equal "You are not authorized to perform this action", flash[:alert]
      end

      test "Challenge managers cannot start other managers model evaluation" do
        model =  create(:model, owner: users("szymon"))
        users(:szymon).update(groups: [ "plggmeetween" ])
        create(:membership, user: users(:szymon), challenge: challenges(:global), roles: [ "manager" ])
        hypothesis = create(:hypothesis, model:)

        challenge_member_signs_in("marek", challenges(:global), teams: [ "plggmeetween" ])
        post hypothesis_evaluations_path(hypothesis_id: hypothesis, format: :turbo_stream)

        assert_response :not_found
      end

      test "Challenge managers can start external users model evaluations" do
        challenges(:global).access_rules.required.update_all(required: false)
        create(:membership, user: users(:external), challenge: challenges(:global), roles: [])
        model =  create(:model, owner: users("external"))
        hypothesis = create(:hypothesis, model:)

        challenge_member_signs_in("marek", challenges(:global), teams: [ "plggmeetween" ])
        post hypothesis_evaluations_path(hypothesis_id: hypothesis, format: :turbo_stream)

        assert_response :success
        assert_equal "Evaluations queued to submit", flash[:notice]
      end
    end
  end
end
