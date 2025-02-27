class AddFromAndToToEvaluator < ActiveRecord::Migration[8.0]
  def change
    add_column :evaluators, :from, :enum, enum_type: :format, null: true
    add_column :evaluators, :to, :enum, enum_type: :format, null: true
  end
end
