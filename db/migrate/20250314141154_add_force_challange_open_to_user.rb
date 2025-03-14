class AddForceChallangeOpenToUser < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :force_challenge_open, :boolean, null: false, default: false
  end
end
