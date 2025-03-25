class HypothesisPolicy < ApplicationPolicy
  def create?
    challenge_open_for_user?
  end

  def destroy?
    challenge_open_for_user?
  end
end
