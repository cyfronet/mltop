class CreateEvaluators < ActiveRecord::Migration[7.2]
  def change
    create_table :evaluators do |t|
      t.string :name, null: false
      t.text :script, null: false
      t.string :host, null: false

      t.timestamps
    end
  end
end
