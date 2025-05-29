class HypothesisPolicy < ApplicationPolicy
  def create?
    challenge_open?
  end

  def destroy?
    challenge_open?
  end
end
