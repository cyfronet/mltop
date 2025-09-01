module Challenges
  module Dashboard
    class ChallengePolicy < ApplicationPolicy
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
        [ :name, :starts_at, :ends_at, :description, :visibility, :logo ]
      end
    end
  end
end
