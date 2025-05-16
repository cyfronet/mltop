class Score < ApplicationRecord
  belongs_to :evaluation
  belongs_to :metric

  validates :value, presence: true, numericality: true
  validates :metric, uniqueness: { scope: :evaluation_id }
  validate :value_within_range

  def value_within_range
    proper_range = if metric.asc?
      (metric.best_score..metric.worst_score).cover?(value)
    else
      (metric.worst_score..metric.best_score).cover?(value)
    end
    errors.add(:value, "is not within the range of the metric") unless proper_range
  end
end
