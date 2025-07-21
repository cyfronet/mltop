class ChallengePolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    admin?
  end

  def create?
    admin?
  end

  def destroy?
    admin?
  end

  def permitted_attributes
    [ :name, :starts_at, :ends_at, :description, :visibility ]
  end
end
