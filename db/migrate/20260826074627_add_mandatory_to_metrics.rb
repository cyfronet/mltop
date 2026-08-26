class AddMandatoryToMetrics < ActiveRecord::Migration[8.1]
  def change
    add_column :metrics, :mandatory, :boolean, default: false, null: false
  end
end
