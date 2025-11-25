class AddSiteReferenceToEvaluator < ActiveRecord::Migration[8.0]
  def change
    add_reference :evaluators, :site, null: true
  end
end
