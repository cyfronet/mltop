module Challenges
  module TestSets
    class LeaderboardsPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          leaderboard_released? ? Current.challenge.test_sets : TestSet.none
        end
      end
    end
  end
end
