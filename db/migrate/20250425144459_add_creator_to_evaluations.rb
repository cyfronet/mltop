class AddCreatorToEvaluations < ActiveRecord::Migration[8.0]
  def change
    add_reference :evaluations, :creator, null: true, foreign_key: { to_table: :users }
  end
end
