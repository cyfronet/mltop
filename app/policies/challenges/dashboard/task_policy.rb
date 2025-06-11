module Challenges
  module Dashboard
    class TaskPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          Current.challenge.tasks
        end
      end

      def new?
        admin_or_challenge_editor?
      end

      def create?
        admin_or_challenge_editor?
      end

      def edit?
        admin_or_challenge_editor?
      end

      def update?
        admin_or_challenge_editor?
      end

      def destroy?
        admin_or_challenge_editor?
      end
    end
  end
end
