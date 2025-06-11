module Challenges
  module Dashboard
    class TasksController < ApplicationController
      before_action :find_and_authorize_task, only: %i[edit update destroy]

      def index
        @tasks = Task.all
      end

      def show
        @task = Task.includes(:challenge, test_sets: { entries: { input_attachment: :blob } }).find(params[:id])
        @test_sets_left = (TestSet.count - @task.test_sets.count).positive?
      end

      def new
        @task = Task.new
        authorize(@task)
        @evaluators = Evaluator.all
        @challenges = Challenge.all
      end

      def create
        @task = Task.new(task_params)

        if @task.save
          redirect_to dashboard_task_path(@task), notice: "Task was successfully created."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        @evaluators = @task.compatible_evaluators
        @challenges = Challenge.all
      end

      def update
        if @task.update(task_params)
          redirect_to dashboard_task_path(@task), notice: "Task was successfully updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if @task.delete
          redirect_to dashboard_tasks_path, notice: "Task \"#{@task}\" was sucessfully deleted."
        else
          redirect_to dashboard_task_path(@task), alert: "Unable to delete task."
        end
      end

      private
        def task_params
          params.expect(task: [
            :name, :slug, :info, :description, :from, :to, :challenge_id, evaluator_ids: []
          ])
        end

        def find_and_authorize_task
          @task = policy_scope(Task).find(params[:id])
          authorize(@task)
        end
    end
  end
end
