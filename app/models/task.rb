class Task < ApplicationRecord
  has_many :task_model, dependent: :destroy
  has_many :models, through: :task_model

  has_many :subtasks, dependent: :destroy

  has_many :test_sets, dependent: :destroy

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

  def to_s
    "#{name} (#{slug})"
  end
end
