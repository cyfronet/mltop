class EvaluatorsController < ApplicationController
  allow_unauthenticated_access only: :show

  def show
    @evaluator = Evaluator.find(params[:id])
  end

  def index
    evaluators = Evaluator.all
    evaluators = evaluators.where(input_modality: params[:input_modality]) unless params[:input_modality].empty?
    evaluators = evaluators.where(output_modality: params[:output_modality]) unless params[:output_modality].empty?
    render json: evaluators
  end
end
