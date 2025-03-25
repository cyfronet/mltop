class ModelPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      models_visible_for_user? ? scope.all : scope.none
    end

    private
      def models_visible_for_user?
        Mltop.ranking_released? || user&.meetween_member?
      end
  end

  def index?
    true
  end

  def show?
    models_visible_for_user?
  end

  def new?
    challenge_open_for_user? || user&.meetween_member?
  end

  def create?
    challenge_open_for_user? || user&.meetween_member?
  end

  def edit?
    challenge_open_for_user? || user&.meetween_member?
  end

  def update?
    challenge_open_for_user? || user&.meetween_member?
  end

  def destroy?
    challenge_open_for_user? || user&.meetween_member?
  end

  protected
    def models_visible_for_user?
      Mltop.ranking_released? || user&.meetween_member?
    end
end
