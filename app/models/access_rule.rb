class AccessRule < ApplicationRecord
  include RoleModel
  belongs_to :challenge

  roles :participant, :manager

  after_update_commit :update_memberships
  after_destroy_commit :update_memberships
  after_create_commit :update_memberships

  scope :management, -> { where(roles_mask: AccessRule.mask_for(:manager)) }
  validates :group_name, presence: true, uniqueness: { scope: :challenge_id }

  private
    def update_memberships
      challenge.update_memberships
    end
end
