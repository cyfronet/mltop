class Submissions::TasksController < ApplicationController
  def index
    model = Current.user.models.find(params[:submission_id])
    redirect_to submission_task_path(model, model.tasks.first)
  end

  def show
    @model = Current.user.models.find(params[:submission_id])
    @task = @model.tasks.find(params[:id])
  end
end
