class AddVisibilityToModel < ActiveRecord::Migration[8.1]
  def up
    create_enum :model_visibility, [ "internal", "visible" ]
    add_column :models, :visibility, :enum, enum_type: :model_visibility

    Model.connection.execute <<~SQL
      UPDATE models
      SET visibility = 'visible'
    SQL
  end

  def down
    remove_column :models, :visibility
    drop_enum :model_visibility
  end
end
