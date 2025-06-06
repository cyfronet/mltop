class MembershipPolicy < ApplicationPolicy
  def create?
    challenge_open?
  end

  def permitted_attributes
    [ agreements_attributes: [ :agreementable_id, :agreementable_type, :consent_id, :agreed ] ]
  end
end
