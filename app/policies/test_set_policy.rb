class TestSetPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      challenge_open_for_user? ? scope.all : scope.none
    end
  end

  def show?
    challenge_open_for_user? || user&.meetween_member?
  end
end
