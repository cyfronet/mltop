class CreateModels < ActiveRecord::Migration[7.2]
  def change
    create_table :models do |t|
      t.string :name

      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
