module Challenges
  module Dashboard
    class EvaluatorPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          Current.challenge ? Current.challenge.evaluators : Evaluator.all
        end
      end

      def show?
        challenge_admin?
      end

      def new?
        challenge_admin?
      end

      def create?
        challenge_admin?
      end

      def edit?
        challenge_admin?
      end

      def update?
        challenge_admin?
      end

      def destroy?
        challenge_admin?
      end
    end
  end
end
