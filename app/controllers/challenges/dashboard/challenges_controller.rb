module Challenges
  module Dashboard
    class ChallengesController < ApplicationController
      before_action :set_and_authorize_challenge

      def edit
      end

      def update
        if @challenge.update(permitted_attributes(@challenge))
          redirect_to challenge_path(@challenge), notice: "Challenge was successfully updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if @challenge.destroy
          redirect_to challenges_path, notice: "Challenge \"#{@challenge}\" was sucessfully deleted."
        else
          redirect_to challenges_path, alert: "Unable to delete challenge."
        end
      end

      private
        def set_and_authorize_challenge
          @challenge = Current.challenge
          authorize(@challenge)
        end
    end
  end
end
