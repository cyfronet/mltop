class AddGroupSubmissionReferenceToHypothesis < ActiveRecord::Migration[8.1]
  def change
    add_reference :hypotheses, :group_submission, foreign_key: true, null: true
  end
end
