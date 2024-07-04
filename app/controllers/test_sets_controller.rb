class TestSetsController < ApplicationController
  allow_unauthenticated_access only: [ :show ]

  def show
    @test_set = TestSet.find(params[:id])
    @tasks = @test_set.tasks
  end
end
