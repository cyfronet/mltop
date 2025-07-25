class Membership < ApplicationRecord
  include Agreementable

  belongs_to :user
  belongs_to :challenge

  validate :user_belongs_to_allowed_group

  def user_belongs_to_allowed_group
    errors.add(:user, "You do not belong to allowed group within the challenge") if
      (user.groups.pluck(:name) & challenge.allowed_groups.pluck(:group_name)).empty?
  end
end
