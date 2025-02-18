class EvaluationsController < ApplicationController
  before_action :load_hypothesis
  meetween_members_only

  def create
    evaluation = @hypothesis.evaluations.create!(evaluation_params)
    evaluation.run_later(Current.user)

    flash.now[:notice] = "Evaluation queued to submit"
  rescue ActiveRecord::RecordInvalid
    flash.now[:alert] = "Unable to create evaluation"
    render status: :bad_request
  end

  private
    def load_hypothesis
      @hypothesis = Hypothesis
        .where(model: my_or_external_models)
        .find(hypothesis_id)
    end

    def hypothesis_id
      params.expect(evaluation: [ :hypothesis_id ]).fetch(:hypothesis_id)
    end

    def evaluation_params
      params.expect(evaluation: [ :evaluator_id ])
    end

    def my_or_external_models
      Model.external.or(Model.where(owner: Current.user))
    end
end
