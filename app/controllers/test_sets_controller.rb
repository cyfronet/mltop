class TestSetsController < ApplicationController
  allow_unauthenticated_access

  def index
    @test_sets = policy_scope(TestSet).includes(:tasks).published
  end

  def show
    @test_set = TestSet.published.find(params[:id])
    authorize(@test_set)
    @tasks = @test_set.tasks
  end
end
