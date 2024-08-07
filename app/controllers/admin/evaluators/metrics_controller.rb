module Admin
  module Evaluators
    class MetricsController < ApplicationController
      before_action :set_evaluator, only: %i[ new create ]
      before_action :set_metric, only: %i[ edit update destroy ]

      def new
        @metric = @evaluator.metrics.build
      end

      def create
        @metric = @evaluator.metrics.build(metric_params)
        if @metric.save
          flash.now[:notice] = "Evaluator metric was successfully created."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit
      end

      def update
        if @metric.update(metric_params)
          redirect_to admin_evaluator_path(@metric.evaluator),
            notice: "Evaluator metric was successfully updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if @metric.destroy
          redirect_to admin_evaluator_path(@metric.evaluator),
            notice:  "\"#{@metric.name}\" metric was sucessfully deleted."
        else
          redirect_to admin_evaluator_path(@metric.evaluator),
            alert: "Unable to delete \"#{@metric.name}\" metric."
        end
      end

      private
        def set_evaluator
          @evaluator = Evaluator.find(params[:evaluator_id])
        end

        def set_metric
          @metric = Metric.find(params[:id])
        end

        def metric_params
          params.require(:metric).permit(:name)
        end
    end
  end
end
