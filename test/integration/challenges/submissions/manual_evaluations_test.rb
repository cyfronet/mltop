# frozen_string_literal: true

require "test_helper"

module Challenges
  module Submissions
    class ManualEvaluationsTest < ActionDispatch::IntegrationTest
      def setup
        in_challenge!
        challenge_member_signs_in("marek", challenges(:global), teams: [ "plggmeetween" ])

        membership = build(:membership, user: users(:external), challenge: challenges(:global))
        membership.save!(validate: false)
        @evaluator = create(:evaluator, kind: :manual)
        create(:metric, evaluator: @evaluator, name: "metric_1", strict: true)
        @model = create(:model, owner: users(:external))
        @hypothesis = create(:hypothesis, model: @model)
      end

      test "creates manual evaluation successfully" do
        assert_difference "Evaluation.count" do
          post hypothesis_manual_evaluations_path(@hypothesis, format: :turbo_stream),
            params: {
              evaluation: {
                evaluator_id: @evaluator.id,
                metric_1: 0.5
              }
            }
        end

        assert_response :success
        assert_equal "Manual scores recorded successfully", flash[:notice]
      end

      test "fails to create manual evaluation with invalid data" do
        post hypothesis_manual_evaluations_path(@hypothesis, format: :turbo_stream),
          params: {
            evaluation: {
              evaluator_id: @evaluator.id,
              metric_1: "-5"
            }
          }

        assert_equal "Unable to record scores", flash[:alert]
      end
    end
  end
end
