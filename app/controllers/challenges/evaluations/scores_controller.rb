module Challenges
  module Evaluations
    class ScoresController < Evaluations::ApplicationController
      def create
        if params[:state] == "OK"
          @evaluation.record_scores!(scores_params)
        else
          @evaluation.record_error!(params[:message])
        end

        head :created
      end

      def scores_params
        params.required(:scores).permit(metrics)
      end

      def metrics
      @evaluation.metrics.map(&:name)
      end
    end
  end
end
