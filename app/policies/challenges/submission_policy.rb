module Challenges
  class SubmissionPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        Current.challenge.models.where(owner: Current.user)
      end
    end

    def index?
      true
    end

    def show?
      owner?
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

    private

    def owner?
      record.owner == user
    end
  end
end
