class Evaluator < ApplicationRecord
  belongs_to :challenge, required: false

  has_many :task_evaluators
  has_many :tasks, through: :task_evaluators

  has_many :metrics, dependent: :destroy

  has_many :evaluations, dependent: :destroy

  validates :name, :script, :host, presence: true

  enum :from, Task::TYPES, prefix: true
  enum :to, Task::TYPES, prefix: true

  def to_s = name
end
