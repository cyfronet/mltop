class ModelBenchmarks::Metric < ApplicationRecord
  belongs_to :benchmark,
    class_name: "ModelBenchmark", inverse_of: :metrics

  has_many :scores,
    class_name: "Models::Score",
    dependent: :destroy

  validates :name, presence: true
end
