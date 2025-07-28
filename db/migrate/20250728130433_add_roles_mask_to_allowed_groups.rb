class AddRolesMaskToAllowedGroups < ActiveRecord::Migration[8.0]
  def change
    add_column :allowed_groups, :roles_mask, :integer, default: 0, null: false
  end
end
