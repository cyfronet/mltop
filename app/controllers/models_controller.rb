class ModelsController < ApplicationController
  allow_unauthenticated_access

  def index
    @models = policy_scope(Model)
  end

  def show
    @model = Model.includes(:tasks).find(params[:id])

    authorize(@model)

    @tasks = @model.tasks
    @task = find_by_query_param(@tasks, :tid)

    @test_sets = @task.test_sets.published
    @metrics = @task.metrics

    @test_set = find_by_query_param(@test_sets, :tsid)
    @metric = find_by_query_param(@metrics, :mid)
    @model_row = Model::Scores.new(model: @model, task: @task, metric: @metric, test_set: @test_set)
  end

  private
    def find_by_query_param(collection, key)
      collection = collection.to_a

      collection.to_a.find { |record| record.id.to_s == params[key] } ||
        collection.first
    end
end
