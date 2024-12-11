class ExternalSubmissionsController < ApplicationController
  before_action do
    unless Current.user.meetween_member?
      redirect_back fallback_location: root_path,
        alert: "Only Meetween members can manage external users submissions"
    end
  end

  def index
    @models = Model.external.with_not_evaluated_hypothesis
  end
end
