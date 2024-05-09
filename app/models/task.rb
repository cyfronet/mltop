class Task < ApplicationRecord
  has_many :task_model, dependent: :destroy
  has_many :models, through: :task_model

  has_many :subtasks, dependent: :destroy

  has_many :test_sets, dependent: :destroy

  has_many :task_evaluators
  has_many :evaluators, through: :task_evaluators
  has_many :metrics, through: :evaluators

  with_options presence: true do
    validates :name
    validates :slug, length: { maximum: 15 }
    validates :from
    validates :to
  end

  TYPES = { movie: "movie", audio: "audio", text: "text" }
  enum :from, TYPES, prefix: true
  enum :to, TYPES, prefix: true
end
