class TaskModel < ApplicationRecord
  belongs_to :task
  belongs_to :model

  validates :model, uniqueness: { scope: :task_id }
  validate :challenge_alignment

  def challenge_alignment
    errors.add(:model_id, :invalid) if model.challenge_id != task.challenge_id
  end
end
