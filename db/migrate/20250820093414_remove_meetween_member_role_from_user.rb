class RemoveMeetweenMemberRoleFromUser < ActiveRecord::Migration[8.0]
  def up
    execute "UPDATE users SET roles_mask = roles_mask & ~2 WHERE roles_mask & 2 != 0"
  end
end
