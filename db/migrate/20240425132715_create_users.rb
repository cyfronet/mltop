class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :plgrid_login
      t.string :email
      t.string :uid
      t.integer :roles_mask

      t.timestamps
    end
  end
end
