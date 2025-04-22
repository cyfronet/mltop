class Admin::EvaluatorsController < Admin::ApplicationController
  before_action :find_evaluator, only: %i[ show edit update destroy ]

  def index
    @evaluators = Evaluator.includes(:challenge).all
  end

  def show
  end

  def new
    @evaluator = Evaluator.new
    @challenges = Challenge.all
  end

  def create
    @evaluator = Evaluator.new(evaluator_params)

    if @evaluator.save
      redirect_to admin_evaluator_path(@evaluator), notice: "Evaluator was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @challenges = Challenge.all
  end

  def update
    if @evaluator.update(evaluator_params)
      redirect_to admin_evaluator_path(@evaluator), notice: "Evaluator was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @evaluator.destroy
      redirect_to admin_evaluators_path, notice: "Evaluator \"#{@evaluator}\" was sucessfully deleted."
    else
      redirect_to admin_evaluator_path(@evaluator), alert: "Unable to delete evaluator."
    end
  end

  private
    def evaluator_params
      params.required(:evaluator).permit(:name, :script, :host, :from, :to, :challenge_id)
    end

    def find_evaluator
      @evaluator = Evaluator.find(params[:id])
    end
end
