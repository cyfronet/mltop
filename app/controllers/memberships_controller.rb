class MembershipsController < ApplicationController
  def create
    if Membership.create(user: Current.user, challenge: Current.challenge)
      redirect_to root_path, notice: "Successfully joined challenge."
    else
      redirect_back fallback_location: root_path, alert: "An error occurred while joining challenge."
    end
  end
end
