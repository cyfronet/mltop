class Evaluators::Metric < ApplicationRecord
  belongs_to :evaluator,
    class_name: "Evaluator", inverse_of: :metrics

  has_many :scores,
    class_name: "Models::Score",
    dependent: :destroy

  validates :name, presence: true
end
