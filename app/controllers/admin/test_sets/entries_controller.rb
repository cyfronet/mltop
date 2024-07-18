module Admin
  module TestSets
    class EntriesController < ApplicationController
      def index
        @test_set = TestSet.find(params[:test_set_id])
        @entries = @test_set.entries
        render json: @entries.map { |entry| { id: entry.id, name: entry.name } }, status: :ok
      end
    end
  end
end
