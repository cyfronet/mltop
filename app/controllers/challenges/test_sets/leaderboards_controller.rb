module Challenges
  module TestSets
    class LeaderboardsController < ApplicationController
      allow_unauthenticated_access
      scoped_authorization :challenges, :public

      helper_method :selected_order, :selected_metric, :selected_test_set, :selected_test_set_entry

      def show
        @test_set = policy_scope(TestSet).find_by(id: params[:test_set_id])
        return unless @test_set
        authorize(@test_set, :leaderboard?)

        @tasks = @test_set.tasks
        @test_set_entries = @test_set.entries.for_task(selected_task)

        @rows = Top::Row
          .where(task: selected_task, test_set: @test_set)
          .order(test_set: @test_set, metric: selected_metric, order: selected_order, test_set_entry: selected_test_set_entry)
        @rows.relative! if params[:color] != "absolute"
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

        def selected_test_set_entry
          @selected_test_set_entry ||= TestSetEntry.find_by(id: params[:sid]) if params[:sid].present?
        end
    end
  end
end
