module Challenges
  module Dashboard
    class EvaluatorsController < ApplicationController
      before_action :find_and_authorize_evaluator, only: %i[ show edit update destroy ]

      def index
        @evaluators = Evaluator.includes(:challenge).all
      end

      def show
      end

      def new
        @evaluator = Evaluator.new
        authorize(@evaluator)
        @challenges = Challenge.all
      end

      def create
        @evaluator = Evaluator.new(evaluator_params)

        if @evaluator.save
          redirect_to dashboard_evaluator_path(@evaluator), notice: "Evaluator was successfully created."
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        @challenges = Challenge.all
      end

      def update
        if @evaluator.update(evaluator_params)
          redirect_to dashboard_evaluator_path(@evaluator), notice: "Evaluator was successfully updated."
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def destroy
        if @evaluator.destroy
          redirect_to dashboard_evaluators_path, notice: "Evaluator \"#{@evaluator}\" was sucessfully deleted."
        else
          redirect_to dashboard_evaluator_path(@evaluator), alert: "Unable to delete evaluator."
        end
      end

      private
      def evaluator_params
        params.required(:evaluator).permit(:name, :script, :host, :from, :to, :challenge_id)
      end

      def find_and_authorize_evaluator
        @evaluator = policy_scope(Evaluator).find(params[:id])
        authorize(@evaluator)
      end
    end
  end
end
