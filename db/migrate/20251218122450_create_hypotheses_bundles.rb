class CreateHypothesesBundles < ActiveRecord::Migration[8.1]
  def change
    create_enum :hypotheses_bundle_state, [ "processing", "failed", "success" ]

    create_table :hypotheses_bundles do |t|
      t.references :model, foreign_key: true
      t.string :name, null: false
      t.string :error_message
      t.enum :state, enum_type: :hypotheses_bundle_state, null: false, default: "processing"

      t.timestamps
    end
  end
end
