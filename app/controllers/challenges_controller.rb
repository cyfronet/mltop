class ChallengesController < ApplicationController
  before_action :set_and_authorize_challenge, only: [ :show, :edit, :update, :destroy ]

  def index
    @challenges = Challenge.all
    authorize(@challenges)
  end

  def show
  end

  def new
    @challenge = Challenge.new
    authorize(@challenge)
  end

  def create
    @challenge = Current.user.challenges.build(permitted_attributes(Challenge))
    authorize(@challenge)

    if @challenge.save
      redirect_to challenge_path(@challenge), notice: "Challenge was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

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
      redirect_to challenge_path(@challenge), alert: "Unable to delete challenge."
    end
  end

  private
    def set_and_authorize_challenge
      @challenge = Challenge.find(params[:id])
      authorize(@challenge)
    end
end
