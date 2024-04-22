class CreateModelBenchmarksMetrics < ActiveRecord::Migration[7.2]
  def change
    create_table :model_benchmarks_metrics do |t|
      t.string :name

      t.references :benchmark, null: false, foreign_key: { to_table: "model_benchmarks" }

      t.timestamps
    end
  end
end
