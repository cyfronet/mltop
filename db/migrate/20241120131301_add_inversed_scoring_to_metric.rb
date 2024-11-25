class AddInversedScoringToMetric < ActiveRecord::Migration[8.0]
  def change
    add_column :metrics, :order, :integer, default: 1, null: false
  end
end
