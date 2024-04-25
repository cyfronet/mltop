class Model < ApplicationRecord
  belongs_to :model_type

  has_many :scores,
    class_name: "Models::Score",
    dependent: :destroy

  validates :name, presence: true

  def self.ordered_by_metric(metric, order: :desc)
    # TODO: Try pure SQL version:
    #   Model.select("models.*, scores.value as score").joins(:scores).where(scores: { metric: }).order(score: :asc)
    #   This is doing n+1 queries for scores. So we need 2 joins here:
    #     1. one for prefeching all scores (needed for table)
    #     2. second for calculating model score.
    #   The pure SQL version can allow method chaining - here collection is
    #   returned.
    sorted = all.includes(:scores).sort_by do |model|
      model.scores.find { |s| s.metric_id == metric.id }&.value || 0
    end

    order&.to_s == "desc" ? sorted.reverse : sorted
    # Model.select("models.*, scores.value as score")
    #   .joins(:scores)
    #   .where(scores: { metric: })
    #   .order(score: :asc)
  end

  def ordered_scores(metrics)
    metrics.map do |metric|
      scores.find { |s| s.metric_id == metric.id }
    end
  end
end
