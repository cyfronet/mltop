class RemoveOrderFromMetric < ActiveRecord::Migration[8.0]
  def change
    remove_column :metrics, :order, :integer, default: 0, null: false
  end
end
