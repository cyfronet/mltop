class Model < ApplicationRecord
  has_many :task_model, dependent: :destroy
  has_many :tasks, through: :task_model

  has_many :evaluations, dependent: :destroy

  has_rich_text :description

  validates :name, presence: true
end
