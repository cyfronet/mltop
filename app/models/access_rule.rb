class AccessRule < ApplicationRecord
  include RoleModel
  belongs_to :challenge

  roles :participant, :manager
  validates :group_name, presence: true, uniqueness: { scope: :challenge_id }
end
