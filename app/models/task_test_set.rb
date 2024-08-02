class TaskTestSet < ApplicationRecord
  belongs_to :task
  belongs_to :test_set

  validates :test_set, uniqueness: { scope: :task }
end
