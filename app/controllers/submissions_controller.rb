class SubmissionsController < ApplicationController
  before_action :set_model, only: [ :show, :update ]

  def index
    @models = Current.user.models
  end

  def show
    @tasks = Task.all
  end

  def new
    @model = Current.user.models.new
    @tasks = Task.all
  end

  def create
    @model = Current.user.models.new(model_params)

    if @model.save
      redirect_to submission_path(@model), notice: "Model created"
    else
      @tasks = Task.all
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @model.update(model_params)
      redirect_to submission_path(@model), notice: "Model updated"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private
    def model_params
      params.required(:model).permit(:name, :description, task_ids: [])
    end

    def set_model
      @model = Current.user.models.find(params[:id])
    end
end
