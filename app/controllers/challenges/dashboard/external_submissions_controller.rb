module Challenges
  module Dashboard
    class ExternalSubmissionsController < ApplicationController
      def index
        authorize(Model, policy_class: ExternalSubmissionPolicy)
        @models = policy_scope(:external_submission).external.with_not_evaluated_hypothesis
      end
    end
  end
end
