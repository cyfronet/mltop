class ModelTypesController < ApplicationController
  def index
    @model_types = ModelType.all
  end

  def show
    @model_type = ModelType.find(params[:id])
  end
end
