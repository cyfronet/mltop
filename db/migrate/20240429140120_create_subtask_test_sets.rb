class CreateSubtaskTestSets < ActiveRecord::Migration[7.2]
  def change
    create_table :subtask_test_sets do |t|
      t.references :subtask, null: false, foreign_key: true
      t.references :test_set, null: false, foreign_key: true

      t.timestamps
    end

    add_index :subtask_test_sets, [ :subtask_id, :test_set_id ], unique: true
  end
end
