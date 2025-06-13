module Challenges
  module Dashboard
    class TestSetPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          Current.challenge.test_sets
        end
      end

      def show?
        challenge_editor?
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
