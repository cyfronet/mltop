class AccessRule < ApplicationRecord
  include RoleModel
  belongs_to :challenge

  roles :participant, :manager

  scope :management, -> { where(roles_mask: AccessRule.mask_for(:manager)) }
  validates :group_name, presence: true, uniqueness: { scope: :challenge_id }
end
