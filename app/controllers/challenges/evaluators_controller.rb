module Challenges
  class EvaluatorsController < ApplicationController
    allow_unauthenticated_access
    scoped_authorization :challenges, :public

    def index
      evaluators = policy_scope(Evaluator)
      evaluators = evaluators.where(from: params[:from]) unless params[:from].empty?
      evaluators = evaluators.where(to: params[:to]) unless params[:to].empty?
      render json: evaluators
    end
  end
end
