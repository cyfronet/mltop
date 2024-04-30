class CreateEvaluatorsMetrics < ActiveRecord::Migration[7.2]
  def change
    create_table :evaluators_metrics do |t|
      t.string :name

      t.references :evaluator, null: false, foreign_key: true

      t.timestamps
    end
  end
end
