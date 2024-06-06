class User < ApplicationRecord
  include RoleModel

  roles :admin
end
