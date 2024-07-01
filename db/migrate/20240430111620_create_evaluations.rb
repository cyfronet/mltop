class CreateEvaluations < ActiveRecord::Migration[7.2]
  def change
    create_table :evaluations do |t|
      # TODO - should point to hypothesis
      # t.references :subtask_test_set, null: false, foreign_key: true
      t.references :model, null: false, foreign_key: true
      t.references :evaluator, null: false, foreign_key: true

      t.timestamps
    end
  end
end
