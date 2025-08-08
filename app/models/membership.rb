class Membership < ApplicationRecord
  include Agreementable

  belongs_to :user
  belongs_to :challenge

  validate :user_satisfies_access_rule

  private
    def user_satisfies_access_rule
      errors.add(:user, "Only #{challenge.access_rules.map(&:group_name).join(",")} group members can join this challenge") unless satisfies_access_rules?
    end

    def satisfies_access_rules?
      (user.groups & challenge.access_rules.pluck(:group_name)).present?
    end
end
