module Challenges
  module Dashboard
    class ExternalSubmissionPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          Current.challenge.models.external.with_not_evaluated_hypothesis
        end
      end

      def index?
        meetween_member?
      end
    end
  end
end
