class CreateTaskTestSets < ActiveRecord::Migration[7.2]
  def change
    create_table :task_test_sets do |t|
      t.references :task, null: false, foreign_key: true
      t.references :test_set, null: false, foreign_key: true

      t.index [ :task_id, :test_set_id ], name: "index_task_test_sets_uniqueness", unique: true
      t.timestamps
    end
  end
end
