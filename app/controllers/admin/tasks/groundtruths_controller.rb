module Admin
  module Tasks
    class GroundtruthsController < ApplicationController
      def new
        @task = Task.preload(test_sets: [ :entries ]).find(params[:task_id])
        @test_sets = @task.test_sets
        @groundtruth = Groundtruth.new
        @test_set = @test_sets.first
        @test_set_entries = @test_sets.first.id
      end

      def create
        @groundtruth = Groundtruth.new(groundtruth_params)
        if @groundtruth.save
          @task = Task.find(params[:task_id])
          redirect_to admin_task_path(@task), notice: "Groundtruth succesfully created"
        else
          @task = Task.find(params[:task_id])
          @test_sets = @task.test_sets
          @test_set = @groundtruth.test_set_entry.test_set
          render(:new, status: :unprocessable_entity)
        end
      end

      private
      def groundtruth_params
        params.require(:groundtruth).permit(:test_set_entry_id, :input, :language)
          .merge({ task_id: params[:task_id] })
      end
    end
  end
end
