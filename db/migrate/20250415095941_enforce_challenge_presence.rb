class EnforceChallengePresence < ActiveRecord::Migration[8.0]
  def change
    change_column_null :models, :challenge_id, false
    change_column_null :tasks, :challenge_id, false
    change_column_null :test_sets, :challenge_id, false
    change_column_null :evaluators, :challenge_id, false
  end
end
