module Challenges
  module Dashboard
    class ConsentPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          Current.challenge.consents
        end
      end

      def index?
        challenge_admin?
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

      def permitted_attributes
        [ :name, :description, :mandatory, :target ]
      end
    end
  end
end
