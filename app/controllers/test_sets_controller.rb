class TestSetsController < ApplicationController
  allow_unauthenticated_access

  def index
    @test_sets = TestSet.includes(:tasks).all
  end

  def show
    @test_set = TestSet.find(params[:id])
    @tasks = @test_set.tasks
  end
end
