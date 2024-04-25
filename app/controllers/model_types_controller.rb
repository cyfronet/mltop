class ModelTypesController < ApplicationController
  helper_method :selected_order, :selected_metric

  def index
    @model_types = ModelType.all
  end

  def show
    @model_type = ModelType.includes(benchmarks: :metrics).find(params[:id])

    @models = @model_type.models
    @models = @models.ordered_by_metric(selected_metric, order: selected_order) if selected_metric
  end

  private
    def selected_order
      params[:o].presence_in([ "asc", "desc" ]) || "desc"
    end

    def selected_metric
      @metric ||= ModelBenchmarks::Metric.find_by(id: params[:mid]) if params[:mid].present?
    end
end
