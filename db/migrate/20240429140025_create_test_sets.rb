class CreateTestSets < ActiveRecord::Migration[7.2]
  def change
    create_table :test_sets do |t|
      t.string :name

      t.timestamps
    end
  end
end
