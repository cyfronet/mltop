class CreateGroundtruths < ActiveRecord::Migration[7.2]
  def change
    create_table :groundtruths do |t|
      t.references :task, null: false, foreign_key: true
      t.references :test_set_entry, null: false, foreign_key: true
      t.string :language, null: false

      t.timestamps
    end
  end
end
