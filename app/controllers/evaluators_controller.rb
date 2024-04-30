class EvaluatorsController < ApplicationController
  allow_unauthenticated_access only: :show

  def show
    @evaluator = Evaluator.find(params[:id])
  end
end
