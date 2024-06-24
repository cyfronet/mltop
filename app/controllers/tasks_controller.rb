class TasksController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]

  helper_method :selected_order, :selected_metric, :selected_test_set

  def index
    @tasks = Task.all
  end

  def show
    @task = Task.includes(:test_sets, :subtasks).find(params[:id])
  end

  private
    def task_params
      params.required(:task).permit(:name, :slug, :description, :from, :to)
    end
end
