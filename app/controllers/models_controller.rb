class ModelsController < ApplicationController
  def show
    @model = Model.find(params[:id])
  end
end
