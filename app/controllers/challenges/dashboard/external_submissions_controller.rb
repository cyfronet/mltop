module Challenges
  module Dashboard
    class ExternalSubmissionsController < ApplicationController
      layout "application"
      def index
        authorize(Model)
        @models = policy_scope(Model).external.with_not_evaluated_hypotheses
      end
    end
  end
end
