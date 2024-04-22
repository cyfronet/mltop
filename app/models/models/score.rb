class Models::Score < ApplicationRecord
  belongs_to :model

  belongs_to :metric,
    class_name: "ModelBenchmarks::Metric"
end
