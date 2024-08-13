class CreateTestSetEntries < ActiveRecord::Migration[7.2]
  def change
    create_table :test_set_entries do |t|
      t.string :source_language, null: false
      t.string :target_language, null: false

      t.references :test_set, null: false, foreign_key: true
      t.references :task, null: false, foreign_key: true

      t.timestamps
    end

    add_index :test_set_entries, [ :source_language, :target_language, :test_set_id, :task_id ], unique: true
  end
end
