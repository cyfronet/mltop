class Score < ApplicationRecord
  belongs_to :evaluation
  belongs_to :metric

  validates :value, presence: true, numericality: true
  validates :metric, uniqueness: { scope: :evaluation_id }
end
