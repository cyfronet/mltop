class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_enum :format, [ "movie", "text" ]

    create_table :tasks do |t|
      t.string :name
      t.enum :from, enum_type: :format, null: false
      t.enum :to, enum_type: :format, null: false

      t.timestamps
    end
  end
end
