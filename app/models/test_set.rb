class TestSet < ApplicationRecord
  belongs_to :task

  has_many :subtask_test_sets, dependent: :destroy
  has_many :subtasks, through: :subtask_test_sets
  has_many :evaluations, through: :subtask_test_sets

  validates :name, presence: true
end
