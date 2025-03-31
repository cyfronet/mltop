class AddChallengeIdToModel < ActiveRecord::Migration[8.0]
  def change
    add_reference :models, :challenge, null: true, foreign_key: true
  end
end
