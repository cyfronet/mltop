class Evaluation < ApplicationRecord
  belongs_to :model
  belongs_to :evaluator
  belongs_to :subtask_test_set

  has_many :scores, dependent: :destroy
end
