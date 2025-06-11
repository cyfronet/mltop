module Challenges
  module Dashboard
    class ChallengePolicy < ApplicationPolicy
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
        [ :name, :starts_at, :ends_at, :description ]
      end
    end
  end
end
