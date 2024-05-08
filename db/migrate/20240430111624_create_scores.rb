class CreateScores < ActiveRecord::Migration[7.2]
  def change
    create_table :scores do |t|
      t.float :value

      t.references :metric, null: false, foreign_key: true
      t.references :evaluation, null: false, foreign_key: true

      t.timestamps
    end

    add_index :scores, [ :metric_id, :evaluation_id ], unique: true
  end
end
