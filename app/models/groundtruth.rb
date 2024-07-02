class Groundtruth < ApplicationRecord
  belongs_to :test_set_entry
  belongs_to :subtask

  has_many :hypotheses, dependent: :destroy

  has_one_attached :input

  validates :test_set_entry, uniqueness: { scope: :subtask_id }
end
