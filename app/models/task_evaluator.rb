class TaskEvaluator < ApplicationRecord
  belongs_to :task
  belongs_to :evaluator

  validates :evaluator, uniqueness: { scope: :task_id }
  validate :evaluator_compatibility

  def evaluator_compatibility
    if evaluator.from && evaluator.from != task.from
      errors.add(:evaluator, "Input modality of evaluator does not match task")
    end

    if evaluator.to && evaluator.to != task.to
      errors.add(:evaluator, "Output modality of evaluator does not match task")
    end
  end
end
