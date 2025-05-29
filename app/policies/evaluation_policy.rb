class EvaluationPolicy < ApplicationPolicy
  def create?
    challenge_open?
  end
end
