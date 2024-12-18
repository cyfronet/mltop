class ChangeUsersRolesMaskDefaultTo0 < ActiveRecord::Migration[8.0]
  def change
    reversible do |direction|
      direction.up do
        execute "UPDATE users SET roles_mask = 0 WHERE roles_mask IS NULL"
      end
    end
    change_column :users, :roles_mask, :integer, null: true, default: 0
  end
end
