class Metric < ApplicationRecord
  belongs_to :evaluator
  has_many :scores, dependent: :destroy

  validates :name, presence: true
end
