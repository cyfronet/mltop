class AddDataConsentToModel < ActiveRecord::Migration[8.0]
  def change
    add_column :models, :data_consent, :boolean, null: false, default: false
  end
end
