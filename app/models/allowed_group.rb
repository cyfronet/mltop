class AllowedGroup < ApplicationRecord
  include RoleModel
  belongs_to :challenge

  roles :participant, :manager
  scope :management, -> { where(roles_mask: AllowedGroup.mask_for(:manager)) }

  validates_presence_of :group_name
end
