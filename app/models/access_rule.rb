class AccessRule < ApplicationRecord
  include RoleModel
  belongs_to :challenge

  roles :participant, :manager

  after_update_commit :update_memberships
  after_destroy_commit :update_memberships
  after_create_commit :update_memberships

  scope :management, -> { where(roles_mask: AccessRule.mask_for(:manager)) }
  validates :group_name, presence: true, uniqueness: { scope: :challenge_id }

  def update_memberships
    Memberships::UpdateRoles.new(challenge:).call
  end
end
