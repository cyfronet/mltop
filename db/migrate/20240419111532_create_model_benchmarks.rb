class CreateModelBenchmarks < ActiveRecord::Migration[7.2]
  def change
    create_table :model_benchmarks do |t|
      t.string :name

      t.references :model_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end