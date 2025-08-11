class AddRolesToMemberships < ActiveRecord::Migration[8.0]
  def change
    add_column :memberships, :roles_mask, :integer, default: 0, null: false
  end
end
