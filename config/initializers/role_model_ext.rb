module RoleModel
  module ClassMethods
    def without_role(*roles)
      (arel_table[:roles_mask] & mask_for(roles)).eq(0)
    end
  end
end
