module Challenges
  class ModelPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        Current.challenge.models
      end
    end

    def index?
      true
    end

    def show?
      true
    end

    def new?
      challenge_open? && challenge_participant?
    end

    def create?
      challenge_open? && challenge_participant?
    end

    def edit?
      challenge_open? && owner? && challenge_participant?
    end

    def update?
      challenge_open? && owner? && challenge_participant?
    end

    def permitted_attributes
      [ :name, :description, task_ids: [], agreements_attributes: [ :consent_id, :agreed, :id ] ]
    end

    private

    def owner?
      record.owner == user
    end
  end
end
