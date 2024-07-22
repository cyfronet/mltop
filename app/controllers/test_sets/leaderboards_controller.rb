class TestSets::LeaderboardsController < ApplicationController
  allow_unauthenticated_access only: [ :show ]

  helper_method :selected_order, :selected_metric, :selected_subtask, :selected_test_set

  def show
    @test_set = TestSet.find(params[:test_set_id])
    @tasks = @test_set.tasks

    @rows = Top::Row
      .where(task: selected_task, test_set: @test_set)
      .order(test_set: @test_set, metric: selected_metric, order: selected_order, subtask: selected_subtask)
  end

  private
    def selected_task
      @task ||= @tasks.detect { |t| t.id.to_s == params[:tid] } || @tasks.first
    end

    def selected_test_set
      @test_set
    end

    def selected_order
      params[:o].presence_in([ "asc", "desc" ]) || "desc"
    end

    def selected_metric
      @selected_metric ||= Metric.find_by(id: params[:mid]) if params[:mid].present?
    end

    def selected_subtask
      @selected_subtask ||= Subtask.find_by(id: params[:sid]) if params[:sid].present?
    end
end
