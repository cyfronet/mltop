module Challenges
  class MembershipPolicy < ApplicationPolicy
    def create?
      challenge_open?
    end

    def permitted_attributes
      [ agreements_attributes: [ :consent_id, :agreed ] ]
    end
  end
end
