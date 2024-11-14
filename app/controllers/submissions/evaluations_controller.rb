
module Submissions
  class EvaluationsController < ApplicationController
    def create
      @hypothesis = Hypothesis.owned_by(Current.user).find(params[:hypothesis_id])
      @hypothesis.evaluate!
      flash.now[:notice] = "Evaluations queued to submit"
    rescue ActiveRecord::RecordInvalid
      flash.now[:alert] = "Unable to create evaluations"
      render status: :bad_request
    end
  end
end
