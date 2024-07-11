module Admin
  module Tasks
    class GroundtruthsController < ApplicationController
      def new
        task = Task.preload(test_sets: [ :entries ]).find(params[:task_id])
        @test_sets = task.test_sets
        @groundtruth = Groundtruth.new
        @test_set = @test_sets.first
        @test_set_entries = @test_sets.first.id
      end

      def create
        @groundtruth = Groundtruth.new(groundtruth_params.merge({ subtask_id: 1 }))
        # @groundtruth = Groundtruth.new(groundtruth_params.merge)
        if @groundtruth.save
          @task = Task.find(params[:task_id])
          redirect_to admin_task_path(@task), notice: "Groundpath succesfully created"
        else
          @task = Task.find(params[:task_id])
          @test_sets = @task.test_sets
          @test_set = @groundtruth.test_set_entry.test_set
          render(:new, status: :unprocessable_entity)
        end
      end

      private
      def groundtruth_params
        params.require(:groundtruth).permit(:test_set_entry_id, :input)
        # params.permit(:test_set_entry_id, :input, :language)
      end
    end
  end
end
