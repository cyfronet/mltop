class SubmissionsController < ApplicationController
  before_action :set_model, only: [ :show, :update ]

  def index
    @models = policy_scope(Model).where(owner: Current.user)
  end

  def show
    @tasks = policy_scope(Task)
  end

  def new
    @model = Current.user.models.new
    @tasks = policy_scope(Task)
  end

  def create
    @model = Current.user.models.new(model_params.merge(challenge: Current.challenge))
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
      @tasks = policy_scope(Task).all
      render view, status: :unprocessable_entity
    end

    def model_params
      params.required(:model).permit(:name, :description, :data_consent, task_ids: [])
    end

    def set_model
      @model = Current.user.models.find(params[:id])
    end
end
