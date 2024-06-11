class Model < ApplicationRecord
  belongs_to :owner, class_name: "User"

  has_many :task_models, dependent: :destroy
  has_many :tasks, through: :task_models
  accepts_nested_attributes_for :tasks, allow_destroy: true

  has_many :evaluations, dependent: :destroy

  has_rich_text :description

  validates :name, presence: true
  validates :task_models, presence: true
end
