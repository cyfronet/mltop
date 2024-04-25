class ModelBenchmarksController < ApplicationController
  def show
    @benchmark = ModelBenchmark.find(params[:id])
  end
end
