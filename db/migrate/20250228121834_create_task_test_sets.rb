class CreateTaskTestSets < ActiveRecord::Migration[8.0]
  def up
    create_table :task_test_sets do |t|
      t.references :task, null: false
      t.references :test_set, null: false

      t.timestamps
    end

    execute(<<~SQL
      INSERT INTO task_test_sets (task_id, test_set_id, created_at, updated_at)
        SELECT DISTINCT ON (task_id, test_set_id) task_id, test_set_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
        FROM test_set_entries
    SQL
    )
  end

  def down
    drop_table :task_test_sets
  end
end
