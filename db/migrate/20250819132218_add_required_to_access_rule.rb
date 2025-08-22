class AddRequiredToAccessRule < ActiveRecord::Migration[8.0]
  def change
    add_column :access_rules, :required, :boolean, null: false, default: false
  end
end
