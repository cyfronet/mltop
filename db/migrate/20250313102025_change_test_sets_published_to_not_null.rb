class ChangeTestSetsPublishedToNotNull < ActiveRecord::Migration[8.0]
  def change
    change_column_null :test_sets, :published, false
  end
end
