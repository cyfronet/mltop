class Membership < ApplicationRecord
  include Agreementable
  include RoleModel

  belongs_to :user
  belongs_to :challenge

  validate :satisfies_access_rules
  roles AccessRule.valid_roles

  def update_role
    challenge.update_membership(self)
  end

  private
    def satisfies_access_rules
      errors.add(:user, "Only #{challenge.access_rules.map(&:group_name).join(",")} group members can join this challenge") unless satisfies_access_rules?
    end

    def satisfies_access_rules?
      challenge.access_rules.size.zero? ||
        (user.groups & challenge.access_rules.pluck(:group_name)).present?
    end
end
