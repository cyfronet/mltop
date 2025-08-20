module Challenges
  class EvaluationPolicy < ApplicationPolicy
    def create?
      challenge_admin? || challenge_manager? && challenge_open?
    end
  end
end
