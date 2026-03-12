class AddKindToEvaluator < ActiveRecord::Migration[8.1]
  def up
    create_enum :evaluator_kind, %w[automatic manual]

    add_column :evaluators, :kind, :enum, enum_type: :evaluator_kind, null: false, default: 'automatic'
    ActiveRecord::Base.connection.execute <<~SQL
      UPDATE evaluators SET kind = 'automatic'
    SQL
  end

  def down
    remove_column :evaluators, :kind
    drop_enum :evaluator_kind
  end
end
