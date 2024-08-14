class Hypothesis < ApplicationRecord
  belongs_to :model
  belongs_to :test_set_entry

  has_many :evaluations, dependent: :destroy

  has_one_attached :input

  validates :input, presence: true
  validates :test_set_entry, uniqueness: { scope: :model }
end
