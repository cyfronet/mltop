module Challenges
  class ConsentsController < ApplicationController
    before_action :set_and_authorize_consent, only: [ :show, :edit, :update, :destroy ]
    before_action :set_challenge, only: %i[ new create ]

    def index
      @consents = Consent.all
      authorize(@consents)
    end

    def show
    end

    def new
      @consent = @challenge.consents.build
      authorize(@consent)
    end

    def create
      @consent = @challenge.consents.build(permitted_attributes(Consent))
      authorize(@consent)

      if @consent.save
        flash.now[:notice] = "Consent was successfully created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @consent.update(permitted_attributes(@consent))
        redirect_to challenge_path(@consent.challenge), notice: "Consent was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @consent.destroy
        redirect_to challenge_path(@consent.challenge), notice: "Consent was sucessfully deleted."
      else
        redirect_to consent_path(@consent), alert: "Unable to delete consent."
      end
    end

    private
    def set_challenge
      @challenge = Challenge.find(params[:challenge_id])
    end

    def set_and_authorize_consent
      @consent = Consent.find(params[:id])
      authorize(@consent)
    end
  end
end
