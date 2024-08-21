class Evaluation < ApplicationRecord
  include Tokenable

  belongs_to :evaluator
  belongs_to :hypothesis

  has_many :metrics, through: :evaluator
  has_many :scores, dependent: :destroy

  def record_scores!(values)
    transaction do
      metrics.each do |metric|
        value = values[metric.name].present? ? values[metric.name].to_f : nil

        scores.create! metric:, value:
      end
    end
  end
end
