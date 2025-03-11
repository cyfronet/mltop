class ConnectTestSetEntriesToTaskTestSet < ActiveRecord::Migration[8.0]
  def up
    add_reference :test_set_entries, :task_test_set, index: true

    execute(<<~SQL
      UPDATE test_set_entries
      SET task_test_set_id = task_test_sets.id
      FROM task_test_sets
      WHERE test_set_entries.task_id = task_test_sets.task_id
      AND test_set_entries.test_set_id = task_test_sets.test_set_id;
    SQL
    )

    remove_reference :test_set_entries, :task
    remove_reference :test_set_entries, :test_set
    change_column_null :test_set_entries, :task_test_set_id, false
  end

  def down
    add_reference :test_set_entries, :test_set, index: true
    add_reference :test_set_entries, :task, index: true

    execute(<<~SQL
     UPDATE test_set_entries
      SET test_set_id = task_test_sets.test_set_id,
        task_id = task_test_sets.task_id
      FROM task_test_sets
      WHERE test_set_entries.task_test_set_id = task_test_sets.id
    SQL
    )

    change_column_null :test_set_entries, :task_id, false
    change_column_null :test_set_entries, :test_set_id, false

    remove_reference :test_set_entries, :task_test_set
  end
end
