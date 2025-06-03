class MembershipsController < ApplicationController
  def create
    if Current.challenge_member?
      redirect_back fallback_location: root_path, alert: "Already member of this challenge."
      return
    end

    if Current.challenge.memberships.create(user: Current.user)
      redirect_to root_path, notice: "Successfully joined challenge."
    else
      redirect_back fallback_location: root_path, alert: "An error occurred while joining challenge."
    end
  end
end
