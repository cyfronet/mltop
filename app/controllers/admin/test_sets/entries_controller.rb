module Admin
  module TestSets
    class EntriesController < ApplicationController
      before_action :find_test_set_entry, only: %i[destroy]
      before_action :find_test_set, only: %i[new index create destroy]

      def index
        @test_set = TestSet.find(params[:test_set_id])
        @entries = @test_set.entries
        render json: @entries.map { |entry| { id: entry.id, name: entry.name } }, status: :ok
      end

      def new
        @test_set_entry = TestSetEntry.new
      end

      def create
        @test_set_entry = TestSetEntry.new(test_set_entry_params.merge({ test_set: @test_set }))
        if @test_set_entry.save
          flash.now[:notice] = "Entry succesfully created"
        else
          render :new, status: :unprocessable_entity
        end
      end

      def destroy
        if @test_set_entry.destroy
          flash.now[:notice] = "Entry succesfully deleted"
          redirect_to admin_test_set_path(@test_set), notice: "Test set entry was successfully removed."
        else
          redirect_to admin_test_set_path(@test_set), alert: "Unable to delete test set entry."
        end
      end

      private
        def find_test_set_entry
          @test_set_entry = TestSetEntry.find(params[:id])
        end

        def find_test_set
          @test_set = TestSet.find(params[:test_set_id])
        end

        def test_set_entry_params
          params.required(:test_set_entry).permit(:language, :input)
        end
    end
  end
end
