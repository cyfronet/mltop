class CreateModelTypes < ActiveRecord::Migration[7.2]
  def change
    create_enum :format, [ "movie", "text" ]

    create_table :model_types do |t|
      t.string :name
      t.column :from, :format, null: false
      t.column :to, :format, null: false

      t.timestamps
    end
  end
end
