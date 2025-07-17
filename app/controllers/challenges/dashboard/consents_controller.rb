module Challenges
  module Dashboard
    class ConsentsController < ApplicationController
      before_action :set_and_authorize_consent, only: [ :edit, :update, :destroy ]

      def index
        @consents = policy_scope(Consent)
        authorize(@consents)
      end

      def new
        @consent = Current.challenge.consents.build
        authorize(@consent)
      end

      def create
        @consent = Current.challenge.consents.build(permitted_attributes(Consent))
        authorize(@consent)

        if @consent.save
          redirect_to dashboard_consents_path,
            notice: "Consent was successfully created."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit
      end

      def update
        if @consent.update(permitted_attributes(@consent))
          redirect_to dashboard_consents_path, notice: "Consent was successfully updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if @consent.destroy
          redirect_to dashboard_consents_path, notice: "Consent was sucessfully deleted."
        else
          redirect_to dashboard_consents_path, alert: "Unable to delete consent."
        end
      end

      private

      def set_and_authorize_consent
        @consent = Consent.find(params[:id])
        authorize(@consent)
      end
    end
  end
end
