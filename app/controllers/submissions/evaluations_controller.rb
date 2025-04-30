
module Submissions
  class EvaluationsController < ApplicationController
    before_action :load_hypothesis
    meetween_members_only

    def create
      @hypothesis.evaluate_missing!(Current.user)
      @evaluators = @hypothesis.evaluators
      flash.now[:notice] = "Evaluations queued to submit"
    rescue ActiveRecord::RecordInvalid
      flash.now[:alert] = "Unable to create evaluations"
      render status: :bad_request
    end

    private
      def load_hypothesis
        @hypothesis = Hypothesis
          .where(model: my_or_external_models)
          .find(params[:hypothesis_id])
      end

      def my_or_external_models
        Model.external.or(Model.where(owner: Current.user))
      end
  end
end
