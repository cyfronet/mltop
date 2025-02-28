class TaskEvaluator < ApplicationRecord
  belongs_to :task
  belongs_to :evaluator

  validates :evaluator, uniqueness: { scope: :task_id }
  validate :matching_task_evaluator

  def matching_task_evaluator
    if evaluator.input_modality && evaluator.input_modality != task.from
      errors.add(:evaluator, "Input modality of evaluator does not match task")
    end

    if evaluator.output_modality && evaluator.output_modality != task.to
      errors.add(:evaluator, "Output modality of evaluator does not match task")
    end
  end
end
