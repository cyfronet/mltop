class Evaluations::MetricsController < Evaluations::ApplicationController
  def create
    @evaluation.record_scores!(scores_params)

    head :created
  end

  def scores_params
    params.required(:scores).permit(metrics)
  end

  def metrics
   @evaluation.metrics.map(&:name)
  end
end
