module Challenges
  class GroupSubmissionPolicy < ApplicationPolicy
    def create?
      user.present? && record.challenge.present?
    end

    def permitted_attributes
      [ :file ]
    end
  end
end
