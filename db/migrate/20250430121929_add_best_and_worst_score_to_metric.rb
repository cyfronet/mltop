class AddBestAndWorstScoreToMetric < ActiveRecord::Migration[8.0]
  def change
    add_column :metrics, :best_score, :float, null: false, default: 0
    add_column :metrics, :worst_score, :float, null: false, default: 100

    change_column_default :metrics, :best_score, from: 0, to: nil
    change_column_default :metrics, :worst_score, from: 100, to: nil
  end
end
