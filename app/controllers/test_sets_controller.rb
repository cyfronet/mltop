class TestSetsController < ApplicationController
  allow_unauthenticated_access

  def index
    @test_sets = TestSet.includes(:tasks).published
  end

  def show
    @test_set = TestSet.published.preload(entries: [ :input_attachment, :task ]).find(params[:id])
    @tasks = @test_set.tasks
  end
end
