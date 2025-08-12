module Challenges
  module Public
    class ModelPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          leaderboard_released? ? Current.challenge.models : Model.none
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
