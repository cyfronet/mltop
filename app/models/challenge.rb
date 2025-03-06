class Challenge < ApplicationRecord
  belongs_to :owner, required: true, class_name: "User"

  has_many :challenge_test_set_entries
  has_many :test_set_entries, through: :challenge_test_set_entries

  has_rich_text :description

  accepts_nested_attributes_for :challenge_test_set_entries

  validates :name, :start_date, :end_date, presence: true
  validates :end_date, comparison: { greater_than: :start_date }


  def to_s = name
end
