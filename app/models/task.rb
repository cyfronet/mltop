class Task < ApplicationRecord
  has_many :models,
    dependent: :destroy

  has_many :benchmarks,
    class_name: "ModelBenchmark",
    dependent: :destroy

  with_options presence: true do
    validates :name
    validates :from
    validates :to
  end

  TYPES = { movie: "movie", audio: "audio", text: "text" }
  enum :from, TYPES, prefix: true
  enum :to, TYPES, prefix: true

  def metrics
    @metrics ||= benchmarks.flat_map(&:metrics)
  end
end
