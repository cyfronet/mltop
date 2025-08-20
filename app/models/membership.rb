class Membership < ApplicationRecord
  include Agreementable
  include RoleModel

  belongs_to :user
  belongs_to :challenge

  validate :satisfies_access_rules
  roles AccessRule.valid_roles + [ :admin ]

  def update_role
    challenge.update_membership(self) unless admin?
  end

  # admin is assigned manually per user, so we don't want to overwrite it when updating other roles
  def calculated_roles=(new_roles)
    self.roles = self.roles.to_a - AccessRule.valid_roles + new_roles
  end

  def calculated_roles
    roles.to_a & AccessRule.valid_roles
  end

  private
    def satisfies_access_rules
      errors.add(:user, "Only #{challenge.access_rules.map(&:group_name).join(",")} group members can join this challenge") unless satisfies_access_rules?
    end

    def satisfies_access_rules?
      admin? ||
      challenge.access_rules.size.zero? ||
        (user.groups & challenge.access_rules.pluck(:group_name)).present?
    end
end
