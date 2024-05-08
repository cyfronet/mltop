class SubtaskTestSet < ApplicationRecord
  belongs_to :subtask
  belongs_to :test_set

  has_many :evaluations, dependent: :destroy

  validates :test_set, uniqueness: { scope: :subtask_id }
end
