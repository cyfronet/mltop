class TestSetsController < ApplicationController
  allow_unauthenticated_access

  def index
    @test_sets = TestSet.includes(:tasks).published
  end

  def show
    @test_set = TestSet.published.preload(task_test_sets: { task: :test_set_entries }).find(params[:id])
    @task_test_sets = @test_set.task_test_sets
  end
end
