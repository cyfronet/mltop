module Challenges
  module Dashboard
    class AccessRulePolicy < ApplicationPolicy
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

      def permitted_attributes
        [ :group_name, :roles ]
      end
    end
  end
end
