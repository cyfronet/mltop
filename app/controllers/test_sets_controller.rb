class TestSetsController < ApplicationController
  allow_unauthenticated_access

  def index
    @test_sets = TestSet.includes(:tasks).published
  end

  def show
    @test_set = TestSet.published.preload(test_set_tasks: { task: :test_set_entries }).find(params[:id])
    @test_set_tasks = @test_set.test_set_tasks
  end
end
