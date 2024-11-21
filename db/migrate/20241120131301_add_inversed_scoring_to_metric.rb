class AddInversedScoringToMetric < ActiveRecord::Migration[8.0]
  def change
    add_column :metrics, :inversed_scoring, :boolean, default: false, null: false
  end
end
