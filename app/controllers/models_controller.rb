class ModelsController < ApplicationController
  allow_unauthenticated_access only: :show

  def show
    @model = Model.includes(:tasks).find(params[:id])

    @tasks = @model.tasks
    @task = find_by_query_param(@tasks, :tid)

    @test_sets = @task.test_sets
    @metrics = @task.metrics

    @test_set = find_by_query_param(@test_sets, :tsid)
    @metric = find_by_query_param(@metrics, :mid)
  end

  private
    def find_by_query_param(collection, key)
      collection = collection.to_a

      collection.to_a.find { |record| record.id.to_s == params[key] } ||
        collection.first
    end
end
