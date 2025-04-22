class TaskPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      Current.challenge ? Current.challenge.tasks : Task.all
    end
  end

  def edit? = user.admin?
  def update? = user.admin?
end
