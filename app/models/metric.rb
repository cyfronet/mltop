class Metric < ApplicationRecord
  belongs_to :evaluator
  has_many :scores, dependent: :destroy

  validates :name, :best_score, :worst_score, presence: true
  validates :worst_score, comparison: { other_than: :best_score }

  def asc?
    best_score < worst_score
  end

  def desc?
    best_score >= worst_score
  end

  def strict?
    strict
  end
end
