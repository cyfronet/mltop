module Challenges
  module Public
    class TestSetsController < ApplicationController
      def index
        @test_sets = policy_scope(TestSet).includes(:tasks).published
      end

      def show
        @test_set = policy_scope(TestSet).published.preload(task_test_sets: [ :task, :test_set_entries ]).find(params[:id])
        @task_test_sets = @test_set.task_test_sets
      end
    end
  end
end
