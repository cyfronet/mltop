class AddProviderToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :provider, :string, null: true
    reversible do |direction|
      direction.up do
        execute "UPDATE users SET provider = 'plgrid'"
        change_column :users, :provider, :string, null: true
      end
    end
  end
end
