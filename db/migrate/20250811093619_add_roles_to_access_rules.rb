class AddRolesToAccessRules < ActiveRecord::Migration[8.0]
  def change
    add_column :access_rules, :roles_mask, :integer, default: 0, null: false
  end
end
