class TaskPolicy < ApplicationPolicy
  def edit? = user.admin?
  def update? = user.admin?
end
