class TestSetPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      Current.challenge ? Current.challenge.test_sets : TestSet.all
    end
  end
end
