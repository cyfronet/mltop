class CreateHypotheses < ActiveRecord::Migration[7.2]
  def change
    create_table :hypotheses do |t|
      t.references :model, null: false, foreign_key: true
      t.references :test_set_entry, null: false, foreign_key: true

      t.timestamps
    end

    add_index :hypotheses, [ :model_id, :test_set_entry_id ], unique: true
  end
end
