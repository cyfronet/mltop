class CreateAgreements < ActiveRecord::Migration[8.0]
  def change
    create_table :agreements do |t|
      t.boolean :agreed, default: false, null: false
      t.references :consent, null: false, foreign_key: true
      t.references :agreementable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
