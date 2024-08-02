class AddSshToUser < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :ssh_key, :text
    add_column :users, :ssh_certificate, :text
  end
end
