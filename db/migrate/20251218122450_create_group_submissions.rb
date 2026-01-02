class CreateGroupSubmissions < ActiveRecord::Migration[8.1]
  def change
    create_enum :group_submission_state, [ "processing", "failed", "success" ]

    create_table :group_submissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :challenge, null: false, foreign_key: true
      t.references :model, foreign_key: true
      t.string :name, null: false
      t.string :error_message
      t.enum :state, enum_type: :group_submission_state, null: false, default: "processing"

      t.timestamps
    end
  end
end
