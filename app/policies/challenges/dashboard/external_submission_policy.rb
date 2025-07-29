module Challenges
  module Dashboard
    class ExternalSubmissionPolicy < ApplicationPolicy
      class Scope < ApplicationPolicy::Scope
        def resolve
          Current.challenge.models.external.with_not_evaluated_hypothesis
        end
      end

      def index?
        challenge_manager?
      end
    end
  end
end
