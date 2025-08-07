module Challenges
  module Dashboard
    class ExternalSubmissionsController < ApplicationController
      def index
        authorize(Model)
        @models = policy_scope(Model).external.with_not_evaluated_hypothesis
      end
    end
  end
end
