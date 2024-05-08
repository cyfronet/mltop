class CreateSubtasks < ActiveRecord::Migration[7.2]
  def change
    create_table :subtasks do |t|
      t.string :name
      t.string :source_language
      t.string :target_language

      t.references :task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
