module Challenges
  class EvaluationPolicy < ApplicationPolicy
    def create?
      challenge_editor? || challenge_manager? && challenge_open?
    end
  end
end
