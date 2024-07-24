module Admin
  module Tasks
    class TestSetsController < ApplicationController
      def new
        @task = Task.preload(:test_sets).find(params[:task_id])
        @test_sets = TestSet.all
        @task_test_set = TaskTestSet.new
      end

      def create
        @task_test_set = TaskTestSet.new(task_test_set_params)

        if @task_test_set.save
          @task = Task.find(params[:task_id])
          redirect_to admin_task_path(@task), notice: "Test set succesfully linked to task"
        else
          @task = Task.find(params[:task_id])
          @test_sets = TestSet.all
          render(:new, status: :unprocessable_entity)
        end
      end

      private
      def task_test_set_params
        params.require(:task_test_set).permit(:test_set_id)
          .merge({ task_id: params[:task_id] })
      end
    end
  end
end
