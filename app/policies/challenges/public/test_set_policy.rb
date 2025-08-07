module Challenges
  module Public
    class TestSetPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          Current.challenge.test_sets.published
        end
      end

      def index?
        true
      end

      def show?
        true
      end

      def leaderboard?
        leaderboard_released?
      end
    end
  end
end
