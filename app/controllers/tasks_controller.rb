class TasksController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]

  helper_method :selected_order, :selected_metric

  def index
    @tasks = Task.all
  end

  def show
    @task = Task.includes(evaluators: :metrics).find(params[:id])

    @models = @task.models
    @models = @models.ordered_by_metric(selected_metric, order: selected_order) if selected_metric
  end

  private
    def selected_order
      params[:o].presence_in([ "asc", "desc" ]) || "desc"
    end

    def selected_metric
      @metric ||= Evaluators::Metric.find_by(id: params[:mid]) if params[:mid].present?
    end
end
