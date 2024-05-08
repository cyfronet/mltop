class CreateTaskEvaluators < ActiveRecord::Migration[7.2]
  def change
    create_table :task_evaluators do |t|
      t.references :task, null: false
      t.references :evaluator, null: false

      t.timestamps
    end

    add_index :task_evaluators, [ :task_id, :evaluator_id ], unique: true
  end
end
