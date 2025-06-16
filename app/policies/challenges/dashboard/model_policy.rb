module Challenges
  module Dashboard
    class ModelPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          Current.challenge.models
        end
      end

      def index?
        meetween_member?
      end
    end
  end
end
