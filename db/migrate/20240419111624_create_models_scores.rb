class CreateModelsScores < ActiveRecord::Migration[7.2]
  def change
    create_table :models_scores do |t|
      t.float :value

      t.references :model, null: false, foreign_key: true
      t.references :metric, null: false, foreign_key: { to_table: "model_benchmarks_metrics" }

      t.timestamps
    end
  end
end
