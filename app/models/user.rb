class User < ApplicationRecord
  include RoleModel
  include User::Plgrid

  encrypts :ssh_key, :ssh_certificate
  has_many :models, inverse_of: :owner, dependent: :destroy

  roles :admin
end
