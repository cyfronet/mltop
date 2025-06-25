module Challenges
  module TestSets
    class LeaderboardsController < ApplicationController
      allow_unauthenticated_access only: [ :show ]

      helper_method :selected_order, :selected_metric, :selected_test_set, :selected_test_set_entry, :relative_scores

      def show
        @test_set = TestSet.find(params[:test_set_id])
        @tasks = @test_set.tasks
        @test_set_entries = @test_set.entries.for_task(selected_task)

        @rows = Top::Row
          .where(task: selected_task, test_set: @test_set)
          .order(test_set: @test_set, metric: selected_metric, order: selected_order, test_set_entry: selected_test_set_entry)
        if relative_scoring?
          @relative_scores = RelativeScores.new(@rows, [ @test_set ], @task.metrics, @test_set_entries)
        end
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

        def relative_scoring?
          params[:color] == "relative"
        end

        def relative_scores
          @relative_scores
        end
    end
  end
end
