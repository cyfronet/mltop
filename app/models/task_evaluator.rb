class TaskEvaluator < ApplicationRecord
  belongs_to :task
  belongs_to :evaluator

  validates :evaluator, uniqueness: { scope: :task_id }
end
