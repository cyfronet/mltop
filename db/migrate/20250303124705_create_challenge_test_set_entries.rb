class CreateChallengeTestSetEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :challenge_test_set_entries do |t|
      t.references :challenge, null: false, index: true
      t.references :test_set_entry, null: false, index: true

      t.timestamps
    end
  end
end
