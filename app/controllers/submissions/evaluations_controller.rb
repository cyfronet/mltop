
module Submissions
  class EvaluationsController < ApplicationController
    def run
      @hypothesis = Hypothesis.preload(:model, test_set_entry: [ task: :evaluators ]).joins(:model).where(models: { owner: Current.user }).find(params[:hypothesis_id])
      if @hypothesis.evaluate!
        flash.now[:notice] = "Evaluations queued to submit"
        @has_evaluations = true
      else
        flash.now[:alert] = "Unable to create evaluations"
        @has_evaluations = false
        render status: :bad_request
      end
    end
  end
end
