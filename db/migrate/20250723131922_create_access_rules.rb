class CreateAccessRules < ActiveRecord::Migration[8.0]
  def change
    create_table :access_rules do |t|
      t.references :challenge, index: true, null: false
      t.string :group_name, null: false

      t.timestamps
    end

    add_index :access_rules, [ :challenge_id, :group_name ], unique: true
  end
end
