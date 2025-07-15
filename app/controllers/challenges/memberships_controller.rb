module Challenges
  class MembershipsController < ApplicationController
    def new
      @consents = Current.challenge.challenge_consents
      @membership = Current.challenge.memberships.build
      Current.challenge.challenge_consents.each do |consent|
        @membership.agreements.build(consent:)
      end
    end

    def create
      if Current.challenge_member?
        redirect_back fallback_location: root_path, alert: "Already member of this challenge."
        return
      end

      @membership = Current.challenge.memberships.build(permitted_attributes(Membership).merge(user: Current.user))
      if @membership.save
        redirect_to post_authenticating_url, notice: "Successfully joined the challenge."
      else
        flash[:alert] = "Couldn't join the challenge."
        render :new, status: :unprocessable_entity
      end
    end
  end
end
