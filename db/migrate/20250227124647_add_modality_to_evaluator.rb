class AddModalityToEvaluator < ActiveRecord::Migration[8.0]
  def change
    add_column :evaluators, :input_modality, :enum, enum_type: :format, null: true
    add_column :evaluators, :output_modality, :enum, enum_type: :format, null: true
  end
end
