module Challenges
  class MembershipsController < ApplicationController
    scoped_authorization :challenges

    before_action :check_for_membership

    def new
      @membership = Current.challenge.memberships.build
      Current.challenge.challenge_consents.each do |consent|
        @membership.agreements.build(consent:)
      end
    end

    def create
      Current.challenge.join!(Current.user, agreements_attributes:)
      redirect_to post_authenticating_url, notice: "Successfully joined the challenge."
    rescue ActiveRecord::RecordInvalid => e
      @membership = e.record
      flash[:alert] = "Couldn't join the challenge. #{@membership.errors[:user]&.first}"
      render :new, status: :unprocessable_entity
    end

    private
      def check_for_membership
        redirect_back fallback_location: root_path,
          alert: "You're already a participant of this challenge." if Current.challenge_member?
      end

      def agreements_attributes
        permitted_attributes(Membership).fetch(:agreements_attributes, [])
      end
  end
end
