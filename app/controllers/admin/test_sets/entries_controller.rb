module Admin
  module TestSets
    class EntriesController < ApplicationController
      before_action :find_test_set, only: %i[ new index create ]

      def index
        @test_set = TestSet.find(params[:test_set_id])
        @entries = @test_set.entries

        render json: @entries.map { |entry| { id: entry.id, name: entry.name } },
               status: :ok
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
        @test_set_entry = TestSetEntry.find(params[:id])

        if @test_set_entry.destroy
          flash.now[:notice] = "Entry succesfully deleted"
        end
      end

      private
        def find_test_set
          @test_set = TestSet.find(params[:test_set_id])
        end

        def test_set_entry_params
          params.required(:test_set_entry).permit(:language, :input)
        end
    end
  end
end
