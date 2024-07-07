class Admin::TasksController < Admin::ApplicationController
  before_action :find_task, only: %i[edit update destroy]
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.includes(test_sets: { entries: { input_attachment: :blob } }).find(params[:id])
    @test_sets_left = (TestSet.count - @task.test_sets.count).positive?
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params.except(:test_set_ids))
    associated_test_sets = TestSet.where(id: task_params[:test_set_ids])
    @task.test_sets = associated_test_sets
    if @task.save
      redirect_to admin_task_path(@task), notice: "Task was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @task.update(task_params.except(:test_set_ids))
      associated_test_sets = TestSet.where(id: task_params[:test_set_ids])
      @task.test_sets = associated_test_sets
      @task.save
      redirect_to admin_task_path(@task), notice: "Task was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @task.delete
      redirect_to admin_tasks_path, notice: "Task \"#{@task}\" was sucessfully deleted."
    else
      redirect_to admin_task_path(@task), alert: "Unable to delete task."
    end
  end

  private
    def task_params
      params.required(:task).permit(:name, :slug, :description, :from, :to, test_set_ids: [])
    end

    def find_task
      @task = Task.find(params[:id])
    end
end
