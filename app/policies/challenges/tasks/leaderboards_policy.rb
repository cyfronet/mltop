module Challenges
  module Tasks
    class LeaderboardsPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          leaderboard_released? ? Current.challenge.tasks.with_published_test_sets : Task.none
        end
      end
    end
  end
end
