class Membership < ApplicationRecord
  include Agreementable
  include RoleModel

  belongs_to :user
  belongs_to :challenge

  validate :user_belongs_to_allowed_group

  roles AllowedGroup.valid_roles

  def user_belongs_to_allowed_group
    errors.add(:user, "You do not belong to allowed group within the challenge") unless
      challenge.can_be_joined_by?(user)
  end
end
