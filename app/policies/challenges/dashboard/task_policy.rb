module Challenges
  module Dashboard
    class TaskPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          Current.challenge.tasks
        end
      end

      def new?
        challenge_editor?
      end

      def create?
        challenge_editor?
      end

      def edit?
        challenge_editor?
      end

      def update?
        challenge_editor?
      end

      def destroy?
        challenge_editor?
      end
    end
  end
end
