class RemoveHostFromEvaluator < ActiveRecord::Migration[8.0]
  def up
    remove_column :evaluators, :host
  end

  def down
    add_column :evaluators, :host, :string

    execute(<<~SQL
      UPDATE evaluators
      SET host = sites.host
      FROM sites
      WHERE evaluators.site_id = sites.id
    SQL
    )

    change_column_null :evaluators, :host, false
  end
end
