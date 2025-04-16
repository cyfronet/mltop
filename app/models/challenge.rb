class Challenge < ApplicationRecord
  belongs_to :owner, required: true, class_name: "User"

  has_many :models, dependent: :destroy
  has_many :tasks, dependent: :nullify
  has_many :test_sets, dependent: :nullify
  has_many :evaluators, dependent: :nullify

  has_rich_text :description

  validates :name, :starts_at, :ends_at, presence: true
  validates :ends_at, comparison: { greater_than: :starts_at }

  validate :meetween_owner

  def to_s = name

  def meetween_owner
    errors.add(:owner, "not a meetween member") unless owner.meetween_member? || owner.admin?
  end
end
