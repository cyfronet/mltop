class ChangeEvaluationsCreatorToMandatory < ActiveRecord::Migration[8.0]
  def change
    change_column_null :evaluations, :creator_id, false
  end
end
