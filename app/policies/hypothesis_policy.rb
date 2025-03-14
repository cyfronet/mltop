class HypothesisPolicy < ApplicationPolicy
  def create?
    challenge_open_for_user?
  end

  def destroy?
    challenge_open_for_user?
  end

  private
    def challenge_open_for_user?
      Mltop.challenge_open? || user.force_challenge_open
    end
end
