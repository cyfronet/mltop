class CreateEvaluations < ActiveRecord::Migration[7.2]
  def change
    create_table :evaluations do |t|
      t.string :token_digest

      t.references :hypothesis, null: false, foreign_key: true
      t.references :evaluator, null: false, foreign_key: true
      t.integer :status, default: 0, null: false
      t.string :job_id

      t.timestamps
    end

    add_index :evaluations, [ :hypothesis_id, :evaluator_id ], unique: true
  end
end
