module Challenges
  class EvaluationPolicy < ApplicationPolicy
    def create?
      meetween_member? && challenge_open?
    end
  end
end
