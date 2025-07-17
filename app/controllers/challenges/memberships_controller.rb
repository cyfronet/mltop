module Challenges
  class MembershipsController < ApplicationController
    before_action :check_for_membership

    def new
      @membership = Current.challenge.memberships.build
      Current.challenge.challenge_consents.each do |consent|
        @membership.agreements.build(consent:)
      end
    end

    def create
      @membership = Current.challenge.memberships.build(permitted_attributes(Membership).merge(user: Current.user))
      if @membership.save
        redirect_to post_authenticating_url, notice: "Successfully joined the challenge."
      else
        flash[:alert] = "Couldn't join the challenge."
        render :new, status: :unprocessable_entity
      end
    end

    private

    def check_for_membership
      redirect_back fallback_location: root_path, alert: "You're already a participant of this challenge." if Current.challenge_member?
    end
  end
end
