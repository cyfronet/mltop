class CreateMetrics < ActiveRecord::Migration[7.2]
  def change
    create_table :metrics do |t|
      t.string :name

      t.references :evaluator, null: false, foreign_key: true

      t.timestamps
    end
  end
end
