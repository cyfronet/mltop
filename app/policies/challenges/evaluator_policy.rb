module Challenges
  class EvaluatorPolicy < ApplicationPolicy
    class Scope < ApplicationPolicy::Scope
      def resolve
        Current.challenge.evaluators
      end
    end

    def index?
      true
    end
  end
end
