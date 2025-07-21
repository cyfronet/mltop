module Challenges
  class SubmissionsController < ApplicationController
    before_action :find_and_authorize_model, only: [ :show, :update ]

    def index
      @models = policy_scope(:submission).where(owner: Current.user)
    end

    def show
      @tasks = policy_scope(Task)
    end

    def new
      @model = Current.user.models.new
      @tasks = policy_scope(Task)
      Current.challenge.model_consents.each do |consent|
        @model.agreements.build(consent:)
      end
    end

    def create
      @model = Current.user.models.new(permitted_attributes(Model).merge(challenge: Current.challenge))
      authorize(@model, policy_class: SubmissionPolicy)
      if @model.save
        redirect_to submission_path(@model), notice: "Model created"
      else
        render_error :new
      end
    end

    def update
      if @model.update(permitted_attributes(Model))
        redirect_to submission_path(@model), notice: "Model updated"
      else
        render_error :show
      end
    end

    private
      def render_error(view)
        @tasks = policy_scope(Task).all
        render view, status: :unprocessable_entity
      end

      def find_and_authorize_model
        @model = policy_scope(:submission).find(params[:id])
        authorize(@model, policy_class: SubmissionPolicy)
      end
  end
end
