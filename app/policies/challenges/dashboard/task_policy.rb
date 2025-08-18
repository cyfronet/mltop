module Challenges
  module Dashboard
    class TaskPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          Current.challenge.tasks
        end
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
