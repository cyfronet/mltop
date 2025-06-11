module Challenges
  module Dashboard
    class TestSetPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          Current.challenge.test_sets
        end
      end

      def show?
        admin_or_challenge_editor?
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
