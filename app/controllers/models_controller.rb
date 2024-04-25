class ModelsController < ApplicationController
  allow_unauthenticated_access only: :show

  def show
    @model = Model.find(params[:id])
  end
end
