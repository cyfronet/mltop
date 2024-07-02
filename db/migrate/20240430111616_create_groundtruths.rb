class CreateGroundtruths < ActiveRecord::Migration[7.2]
  def change
    create_table :groundtruths do |t|
      t.references :subtask, null: false, foreign_key: true
      t.references :test_set_entry, null: false, foreign_key: true

      t.timestamps
    end

    add_index :groundtruths, [ :subtask_id, :test_set_entry_id ], unique: true
  end
end
