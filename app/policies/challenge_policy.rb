class ChallengePolicy < ApplicationPolicy
  def index?
    user.meetween_member?
  end

  def show?
    user.meetween_member?
  end

  def new?
    user.meetween_member?
  end

  def create?
    user.meetween_member?
  end

  def edit?
    challenge_maintainer?
  end

  def update?
    challenge_maintainer?
  end

  def destroy?
    challenge_maintainer?
  end

  def permitted_attributes
    [ :name, :starts_at, :ends_at, :description ]
  end

  private

  def challenge_maintainer?
    user.admin? || (user == record.owner && user.meetween_member?)
  end
end
