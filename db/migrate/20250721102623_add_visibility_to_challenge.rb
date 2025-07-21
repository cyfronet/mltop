class AddVisibilityToChallenge < ActiveRecord::Migration[8.0]
  def change
    create_enum :challenge_visibility, [ "leaderboard_released", "scores_released" ]

    add_column :challenges, :visibility, :enum, enum_type: :challenge_visibility
  end
end
