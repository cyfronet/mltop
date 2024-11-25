class Metric < ApplicationRecord
  belongs_to :evaluator
  has_many :scores, dependent: :destroy

  validates :name, presence: true

  enum :order, {
    asc: 0,
    desc: 1
  }
end
