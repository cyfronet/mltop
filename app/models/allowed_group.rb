class AllowedGroup < ApplicationRecord
  include RoleModel
  belongs_to :challenge

  roles :participant, :manager
  validates_presence_of :group_name
end
