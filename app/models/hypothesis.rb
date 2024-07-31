class Hypothesis < ApplicationRecord
  belongs_to :model
  belongs_to :groundtruth

  has_many :evaluations, dependent: :destroy

  has_one_attached :input

  validates :input, presence: true
end
