class Evaluation < ApplicationRecord
  belongs_to :evaluator
  belongs_to :hypothesis

  has_many :metrics, through: :evaluator
  has_many :scores, dependent: :destroy

  has_secure_password :token, validations: false

  def record_scores!(values)
    transaction do
      metrics.each do |metric|
        value = values[metric.name].present? ? values[metric.name].to_f : nil

        scores.create! metric:, value:
      end
    end
  end

  def reset_token!
    generate_token.tap do |token|
      update! token:
    end
  end

  private
    def generate_token
      SecureRandom.alphanumeric(12).scan(/.{4}/).join("-")
    end
end
