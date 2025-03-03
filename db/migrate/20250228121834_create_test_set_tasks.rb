class CreateTestSetTasks < ActiveRecord::Migration[8.0]
  def up
    create_table :test_set_tasks do |t|
      t.references :task, null: false
      t.references :test_set, null: false

      t.timestamps
    end

    execute(<<~SQL
      INSERT INTO test_set_tasks (task_id, test_set_id, created_at, updated_at)
        SELECT DISTINCT ON (task_id, test_set_id) task_id, test_set_id, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
        FROM test_set_entries
    SQL
    )
  end

  def down
    drop_table :test_set_tasks
  end
end
