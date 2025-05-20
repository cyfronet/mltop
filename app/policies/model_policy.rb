class ModelPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      Current.challenge.models
    end
  end
end
