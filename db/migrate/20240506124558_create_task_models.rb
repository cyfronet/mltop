class CreateTaskModels < ActiveRecord::Migration[7.2]
  def change
    create_table :task_models do |t|
      t.references :task, null: false, foreign_key: true
      t.references :model, null: false, foreign_key: true

      t.timestamps
    end
    add_index :task_models, [ :task_id, :model_id ], unique: true
  end
end
