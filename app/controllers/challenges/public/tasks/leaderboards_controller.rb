module Challenges
  module Public
    module Tasks
      class LeaderboardsController < ApplicationController
        helper_method :selected_order, :selected_metric, :selected_test_set, :filtering_params

        def show
          @task = policy_scope(Task).includes(:metrics).find_by(id: params[:task_id])
          return unless @task
          authorize(@task, :leaderboard?)

          @filtering_params = params.permit(:tsid, :mid, :o, :source, :target)
          @rows = Top::Row
            .where(task: @task,
              source: params[:source],
              target: params[:target])
            .order(test_set: selected_test_set,
              metric: selected_metric,
              order: selected_order
              )

          @rows.relative! if params[:color] == "relative"
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
    end
  end
end
