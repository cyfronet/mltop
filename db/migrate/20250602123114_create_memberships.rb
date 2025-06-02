class CreateMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :memberships do |t|
      t.belongs_to :user, null: false
      t.belongs_to :challenge, null: false

      t.timestamps
    end
  end
end
