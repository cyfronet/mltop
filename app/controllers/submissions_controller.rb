class SubmissionsController < ApplicationController
  before_action :set_and_authorize_model, only: [ :show, :update ]

  def index
    @models = Current.user.models
  end

  def show
    @tasks = Task.all
  end

  def new
    @model = Current.user.models.new
    authorize(@model)
    @tasks = Task.all
  end

  def create
    @model = Current.user.models.new(model_params)
    authorize(@model)

    if @model.save
      redirect_to submission_path(@model), notice: "Model created"
    else
      render_error :new
    end
  end

  def update
    if @model.update(model_params)
      redirect_to submission_path(@model), notice: "Model updated"
    else
      render_error :show
    end
  end

  private
    def render_error(view)
      @tasks = Task.all
      render view, status: :unprocessable_entity
    end
    def model_params
      params.required(:model).permit(:name, :description, task_ids: [])
    end

    def set_and_authorize_model
      @model = Current.user.models.find(params[:id])
      authorize(@model)
    end
end
