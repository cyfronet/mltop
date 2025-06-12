module Challenges
  module Dashboard
    class ModelPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          Current.challenge.models
        end
      end

      def index?
        true
      end
    end
  end
end
