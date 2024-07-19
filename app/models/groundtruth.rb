class Groundtruth < ApplicationRecord
  belongs_to :test_set_entry
  belongs_to :task
  has_many :hypotheses, dependent: :destroy

  has_one_attached :input

  validates :language, presence: true, uniqueness: { scope: :test_set_entry }
end
