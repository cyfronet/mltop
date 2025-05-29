class ModelPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      Current.challenge.models
    end

    def index?
      true
    end

    def show?
      true
    end

    def new?
      challenge_open?
    end

    def create?
      challenge_open?
    end

    def edit?
      challenge_open? && owner?
    end

    def update?
      challenge_open? && owner?
    end

    private

    def owner?
      record.owner == user
    end
  end
end
