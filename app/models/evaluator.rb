class Evaluator < ApplicationRecord
  belongs_to :task

  has_many :metrics,
    class_name: "Evaluators::Metric", foreign_key: "evaluator_id",
    inverse_of: :evaluator,
    dependent: :destroy

  validates :name, presence: true
end
