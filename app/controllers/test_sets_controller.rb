class TestSetsController < ApplicationController
  allow_unauthenticated_access only: [ :show ]

  def show
    @test_set = TestSet.find(params[:id])
    @task = @test_set.task
  end
end
