class CreateEvaluations < ActiveRecord::Migration[7.2]
  def change
    create_table :evaluations do |t|
      t.references :hypothesis, null: false, foreign_key: true
      t.references :evaluator, null: false, foreign_key: true

      t.timestamps
    end
  end
end
