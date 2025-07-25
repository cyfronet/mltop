class AddGroupsToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :groups, :string, array: :true
  end
end
