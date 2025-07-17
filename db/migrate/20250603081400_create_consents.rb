class CreateConsents < ActiveRecord::Migration[8.0]
  def change
    create_enum :consent_target, [ "model", "challenge" ]

    create_table :consents do |t|
      t.belongs_to :challenge, null: false
      t.string :name, null: false
      t.enum :target, enum_type: :consent_target, null: false
      t.boolean :mandatory, default: false

      t.timestamps
    end
  end
end
