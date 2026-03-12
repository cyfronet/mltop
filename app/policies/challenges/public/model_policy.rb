module Challenges
  module Public
    class ModelPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          return Model.none unless leaderboard_released?
          if challenge_admin? || challenge_manager?
            Current.challenge.models
          else
            Current.challenge.models.visible
          end
        end
      end

      def index?
        true
      end

      def show?
        true
      end
    end
  end
end
