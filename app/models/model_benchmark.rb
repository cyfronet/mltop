class ModelBenchmark < ApplicationRecord
  belongs_to :task

  has_many :metrics,
    class_name: "ModelBenchmarks::Metric", foreign_key: "benchmark_id",
    inverse_of: :benchmark,
    dependent: :destroy

  validates :name, presence: true
end
