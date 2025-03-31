class Task < ApplicationRecord
  belongs_to :challenge, required: false

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

  validates_associated :task_evaluators

  TYPES = { video: "video", audio: "audio", text: "text" }
  enum :from, TYPES, prefix: true
  enum :to, TYPES, prefix: true

  scope :with_published_test_sets,
        -> { includes(:test_sets).where(test_sets: { published: [ true, nil ] }) }

  def to_s
    "#{name} (#{slug})"
  end

  def compatible_evaluators
    Evaluator.where(from: [ from, nil ], to:)
  end
end
