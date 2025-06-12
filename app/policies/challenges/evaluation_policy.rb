module Challenges
  class EvaluationPolicy < ApplicationPolicy
    def create?
      challenge_open?
    end
  end
end
