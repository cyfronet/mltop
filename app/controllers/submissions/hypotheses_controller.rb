class Submissions::HypothesesController < ApplicationController
  def index
    @model = Current.user.models.find(params[:submission_id])
  end
end
