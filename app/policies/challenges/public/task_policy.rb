module Challenges
  module Public
    class TaskPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          Current.challenge.tasks.with_published_test_sets
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
