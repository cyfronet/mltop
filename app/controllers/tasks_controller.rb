class TasksController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]

  helper_method :selected_order, :selected_metric, :selected_test_set

  def index
    @tasks = Task.all
  end

  def show
    @task = Task.includes(:test_sets, :subtasks).find(params[:id])
  end

  def new
    @task = Task.new
    authorize @task
  end

  def create
    @task = Task.new(task_params)
    authorize @task

    if @task.save
      redirect_to @task, notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @task = Task.find(params[:id])
    authorize @task
  end

  private
    def task_params
      params.required(:task).permit(:name, :slug, :description, :from, :to)
    end

    def selected_order
      params[:o].presence_in([ "asc", "desc" ]) || "desc"
    end

    def selected_metric
      @metric ||= Metric.find_by(id: params[:mid]) if params[:mid].present?
    end

    def selected_test_set
      @test_set ||= TestSet.find_by(id: params[:tsid]) if params[:tsid].present?
    end
end
