class EvaluatorsController < ApplicationController
  allow_unauthenticated_access only: :show

  def show
    @evaluator = Evaluator.find(params[:id])
  end

  def index
    evaluators = Evaluator.all
    evaluators = evaluators.where(from: params[:from]) unless params[:from].empty?
    evaluators = evaluators.where(to: params[:to]) unless params[:to].empty?
    render json: evaluators
  end
end
