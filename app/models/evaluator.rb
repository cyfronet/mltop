class Evaluator < ApplicationRecord
  has_many :task_evaluators
  has_many :tasks, through: :task_evaluators

  has_many :metrics, dependent: :destroy

  has_many :evaluations, dependent: :destroy

  validates :name, presence: true
end
