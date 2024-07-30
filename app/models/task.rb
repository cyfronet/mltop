class Task < ApplicationRecord
  has_many :task_test_sets, dependent: :destroy
  has_many :test_sets, through: :task_test_sets

  has_many :models, through: :task_models

  has_many :groundtruths, dependent: :destroy do
    def by_test_set(test_set)
      joins(:test_set_entry).where(test_set_entries: { test_set: })
    end
  end

  has_many :task_test_sets, dependent: :destroy
  has_many :test_sets, through: :task_test_sets

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
