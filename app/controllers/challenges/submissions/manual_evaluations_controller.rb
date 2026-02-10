module Challenges
  module Submissions
    class ManualEvaluationsController < ApplicationController
      before_action :load_hypothesis
      before_action :load_evaluator

      def create
        authorize :create?, policy_class: Challenges::ManualEvaluationPolicy

        Evaluation.transaction do
          @evaluation = @hypothesis.evaluations.create!(evaluator: @evaluator, creator: Current.user)
          if @evaluation.persisted?
            @evaluation.record_scores!(scores_params)
            @evaluators = @hypothesis.evaluators
            flash.now[:notice] = "Manual scores recorded successfully"

          else
            flash.now[:alert] = "Unable to create evaluations"
            render status: :unprocessable_entity
          end
        end
      end

      private
        def load_hypothesis
          @hypothesis = Hypothesis
            .where(model: my_or_external_models)
            .find(params[:hypothesis_id])
        end

        def load_evaluator
          @evaluator = policy_scope(Evaluator).manual.find(params.require(:evaluation)[:evaluator_id])
        end

        def scores_params
          params.require(:evaluation).permit(@evaluation.metrics.map(&:name))
        end

        def my_or_external_models
          policy_scope(Model).external.or(
            policy_scope(Model).where(owner: Current.user))
        end
    end
  end
end
