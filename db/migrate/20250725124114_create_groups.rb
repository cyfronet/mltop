class CreateGroups < ActiveRecord::Migration[8.0]
  def change
    create_table :groups do |t|
      t.references :user, null: false, index: true
      t.string :name, null: false

      t.timestamps
    end
  end
end
