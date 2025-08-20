class Metric < ApplicationRecord
  belongs_to :evaluator
  has_many :scores, dependent: :destroy

  validates :name, :best_score, :worst_score, presence: true
  validate :proper_score_range

  enum :order, {
    asc: 0,
    desc: 1
  }

  private
    def proper_score_range
      if asc? && best_score >= worst_score
        errors.add(:best_score, "Best score has to be lesser than worst score")
      end
      if desc? && best_score <= worst_score
        errors.add(:best_score, "Best score has to be greater than worst score")
      end
    end
end
