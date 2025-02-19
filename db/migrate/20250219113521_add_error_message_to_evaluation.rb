class AddErrorMessageToEvaluation < ActiveRecord::Migration[8.0]
  def change
    add_column :evaluations, :error_message, :string
  end
end
