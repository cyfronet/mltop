class ChallengesController < ApplicationController
  meetween_members_only except: [ :index, :show ]
  before_action :load_challenge, only: [ :edit, :update, :destroy ]

  def index
    @challenges = Challenge.all
  end

  def show
    @challenge = Challenge.preload(test_set_entries: [ :test_set, :task ]).find(params[:id])
  end

  def new
    @challenge = Challenge.new
    @tasks = Task.includes(test_set_entries: :test_set).all
  end


  def create
    @challenge = Challenge.new(challenge_params)
    @test_set_entries = TestSetEntry.preload(:test_set, :task).all

    if @challenge.save
      redirect_to challenge_path(@challenge), notice: "Challenge was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @tasks = Task.includes(test_set_entries: :test_set).all
  end

  def update
    if @challenge.update(challenge_params)
      redirect_to challenge_path(@challenge), notice: "Challenge was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @challenge.delete
      redirect_to challenges_path, notice: "Challenge \"#{@challenge}\" was sucessfully deleted."
    else
      redirect_to challenge_path(@challenge), alert: "Unable to delete challenge."
    end
  end

  private

    def load_challenge
      @challenge = Challenge.find(params[:id])
    end

    def challenge_params
      params.expect(challenge: [
        :name, :start_date, :description, :end_date, :owner_id, test_set_entry_ids: []
      ])
    end
end
