class Task < ApplicationRecord
  has_many :task_models, dependent: :destroy
  has_many :models, through: :task_models

  has_many :test_set_entries, dependent: :destroy
  has_many :test_sets, -> { distinct }, through: :test_set_entries

  has_many :task_evaluators
  has_many :evaluators, through: :task_evaluators
  has_many :metrics, through: :evaluators

  has_rich_text :description

  with_options presence: true do
    validates :name
    validates :slug, length: { maximum: 15 }
    validates :from
    validates :to
  end

  TYPES = { video: "video", audio: "audio", text: "text" }
  enum :from, TYPES, prefix: true
  enum :to, TYPES, prefix: true

  scope :with_published_test_sets,
        -> { includes(:test_sets).where(test_sets: { published: true }) }

  def to_s
    "#{name} (#{slug})"
  end
end
