class MemberPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      Current.challenge ? Current.challenge.members : User.all
    end
  end
end
