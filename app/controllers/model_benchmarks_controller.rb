class ModelBenchmarksController < ApplicationController
  allow_unauthenticated_access only: :show

  def show
    @benchmark = ModelBenchmark.find(params[:id])
  end
end
