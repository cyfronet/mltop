class User < ApplicationRecord
  include RoleModel

  has_many :models, inverse_of: :owner, dependent: :destroy

  roles :admin
end
