
module Submissions
  class EvaluationsController < ApplicationController
    def create
      @hypothesis = Hypothesis
        .where(model: my_or_external_models)
        .find(params[:hypothesis_id])

      if Current.user.meetween_member?
        @hypothesis.evaluate!
        flash.now[:notice] = "Evaluations queued to submit"
      else
        flash.now[:alert] = "Only Meetween members can start this evaluation"
        render status: :forbidden
      end
    rescue ActiveRecord::RecordInvalid
      flash.now[:alert] = "Unable to create evaluations"
      render status: :bad_request
    end

    private
      def my_or_external_models
        Model.external.or(Model.where(owner: Current.user))
      end
  end
end
