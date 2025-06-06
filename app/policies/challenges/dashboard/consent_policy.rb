module Challenges
  module Dashboard
    class ConsentPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          Current.challenge.consents
        end
      end

      def index?
        user.meetween_member?
      end

      def show?
        user.meetween_member?
      end

      def new?
        user.meetween_member?
      end

      def create?
        user.meetween_member?
      end

      def edit?
        challenge_maintainer?
      end

      def update?
        challenge_maintainer?
      end

      def destroy?
        challenge_maintainer?
      end

      def permitted_attributes
        [ :name, :description, :mandatory, :target ]
      end

      private

      def challenge_maintainer?
        user.admin? || (user == record.challenge.owner && user.meetween_member?)
      end
    end
  end
end
