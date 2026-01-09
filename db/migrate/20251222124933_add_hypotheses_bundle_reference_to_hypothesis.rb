class AddHypothesesBundleReferenceToHypothesis < ActiveRecord::Migration[8.1]
  def change
    add_reference :hypotheses, :hypotheses_bundle, foreign_key: true, null: true
  end
end
