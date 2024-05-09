class TasksController < ApplicationController
  allow_unauthenticated_access only: [ :index, :show ]

  helper_method :selected_order, :selected_metric, :selected_test_set

  def index
    @tasks = Task.all
  end

  def show
    @task = Task.includes(:test_sets, :subtasks).find(params[:id])
  end

  private
    def selected_order
      params[:o].presence_in([ "asc", "desc" ]) || "desc"
    end

    def selected_metric
      @metric ||= Metric.find_by(id: params[:mid]) if params[:mid].present?
    end

    def selected_test_set
      @test_set ||= TestSet.find_by(id: params[:tsid]) if params[:tsid].present?
    end
end
