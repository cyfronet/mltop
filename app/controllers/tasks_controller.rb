class TasksController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]

  helper_method :selected_order, :selected_metric, :selected_test_set

  def index
    @tasks = Task.all
    @stats = Statistics.new
  end

  def show
    @task = Task.with_published_test_sets.preload(:task_test_sets).find(params[:id])
    @task_test_sets = @task.task_test_sets
  end
end
