module Admin
  module TestSets
    class EntriesController < ApplicationController
      before_action :find_test_set, only: %i[ new create ]

      def new
        @test_set_entry = TestSetEntry.new
      end

      def create
        find_task_test_set
        @test_set_entry = @task_test_set.test_set_entries.build(test_set_entry_params)

        if @task_test_set.save
          flash.now[:notice] = "Entry succesfully created"
        else
          render :new, status: :unprocessable_entity
        end
      end

      def destroy
        @test_set_entry = TestSetEntry.find(params[:id])

        if @test_set_entry.destroy
          flash.now[:notice] = "Entry succesfully deleted"
        end
      end

      private
        def find_test_set
          @test_set = TestSet.find(params[:test_set_id])
        end

        def find_task_test_set
          @task_test_set = TaskTestSet.find_or_initialize_by(test_set_id: params[:test_set_id], task_id: params[:test_set_entry][:task_id])
        end

        def test_set_entry_params
          params.required(:test_set_entry)
            .permit(:source_language, :target_language,
                    :input, :groundtruth)
        end
    end
  end
end
