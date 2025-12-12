class AddDirectoryToEvaluator < ActiveRecord::Migration[8.1]
  def change
    add_column :evaluators, :directory, :string

    execute <<-SQL.squish
      UPDATE evaluators SET directory = '/net/pr2/projects/plgrid/plggmeetween/mltop';
    SQL

    change_column_null :evaluators, :directory, false
  end
end
