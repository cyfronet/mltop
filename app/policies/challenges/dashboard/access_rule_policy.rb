module Challenges
  module Dashboard
    class AccessRulePolicy < ApplicationPolicy
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

      def permitted_attributes
        [ :group_name, :roles, :required ]
      end
    end
  end
end
