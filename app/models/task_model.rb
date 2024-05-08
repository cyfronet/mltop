class TaskModel < ApplicationRecord
  belongs_to :task
  belongs_to :model

  validates :model, uniqueness: { scope: :task_id }
end
