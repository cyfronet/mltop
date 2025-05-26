class Tasks::LeaderboardsController < ApplicationController
  allow_unauthenticated_access only: [ :show ]


  helper_method :selected_order, :selected_metric, :selected_test_set, :filtering_params

  def index
    @tasks = Task.all
  end

  def show
    @filtering_params = params.permit(:tsid, :mid, :o, :source, :target)
    @task = Task.with_published_test_sets.includes(:metrics).find(params[:task_id])
    if Mltop.ranking_released?
      @rows = Top::Row
        .where(task: @task,
          source: params[:source],
          target: params[:target])
        .order(test_set: selected_test_set,
          metric: selected_metric,
          order: selected_order
          )
    else
      @rows = Top::Row.none
    end
  end

  private
    def selected_order
      params[:o].presence_in([ "asc", "desc" ]) || "desc"
    end

    def selected_metric
      @metric ||= Metric.find_by(id: params[:mid]) if params[:mid].present?
    end

    def selected_test_set
      @test_set ||= TestSet.published.find_by(id: params[:tsid]) if params[:tsid].present?
    end

    def filtering_params
      @filtering_params
    end
end
