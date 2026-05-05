class UpdateChallengeVisibility < ActiveRecord::Migration[8.1]
  def up
    ActiveRecord::Base.connection.execute("ALTER TYPE challenge_visibility ADD VALUE 'internal_leaderboard'")
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't remove internal_leaderboard from challenge_visibility enum"
  end
end
