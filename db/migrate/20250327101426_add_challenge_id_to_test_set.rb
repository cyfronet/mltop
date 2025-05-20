class AddChallengeIdToTestSet < ActiveRecord::Migration[8.0]
  def change
    add_reference :test_sets, :challenge, null: true, foreign_key: true
  end
end
