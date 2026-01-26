module Challenges
  module Dashboard
    class EvaluatorsController < ApplicationController
      before_action :find_and_authorize_evaluator, only: %i[ show edit update destroy ]

      def index
        @evaluators = policy_scope(Evaluator).includes(:challenge)
      end

      def show
      end

      def new
        @evaluator = Evaluator.new
        @sites = Site.all
        authorize(@evaluator)
      end

      def create
        @evaluator = Current.challenge.evaluators.build(permitted_attributes(Evaluator))

        if @evaluator.save
          redirect_to dashboard_evaluator_path(@evaluator), notice: "Evaluator was successfully created."
        else
          @sites = Site.all
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        @sites = Site.all
      end

      def update
        if @evaluator.update(permitted_attributes(@evaluator))
          redirect_to dashboard_evaluator_path(@evaluator), notice: "Evaluator was successfully updated."
        else
          @sites = Site.all
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
        def find_and_authorize_evaluator
          @evaluator = policy_scope(Evaluator).find(params[:id])
          authorize(@evaluator)
        end
    end
  end
end
