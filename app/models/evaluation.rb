class Evaluation < ApplicationRecord
  include Tokenable

  belongs_to :evaluator
  belongs_to :hypothesis

  has_many :metrics, through: :evaluator
  has_many :scores, dependent: :destroy

  enum :status, {
    created: 0,
    pending: 1,
    running: 2,
    completed: 3,
    failed: 4
  }

  def record_scores!(values)
    transaction do
      metrics.each do |metric|
        scores.create! metric:, value: values[metric.name]&.to_f
      end
    end
  end
end
