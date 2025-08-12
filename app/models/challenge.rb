class Challenge < ApplicationRecord
  belongs_to :owner, required: true, class_name: "User"

  has_many :models, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :test_sets, dependent: :destroy
  has_many :evaluators, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :members, class_name: "User", source: :user, through: :memberships
  has_many :consents, dependent: :destroy
  has_many :access_rules, dependent: :destroy

  has_rich_text :description

  validates :name, :starts_at, :ends_at, presence: true
  validates :ends_at, comparison: { greater_than: :starts_at }

  validate :meetween_owner

  VISIBILITIES = { leaderboard_released: "leaderboard_released", scores_released: "scores_released" }
  enum :visibility, VISIBILITIES

  def to_s = name

  def meetween_owner
    errors.add(:owner, "not a meetween member") unless owner.meetween_member?
  end

  def status
    now = Time.current
    return "upcoming" if now.before?(starts_at)
    return "closed"   if now.after?(ends_at)
    "ongoing"
  end

  def challenge_consents
    consents.where(target: :challenge)
  end

  def model_consents
    consents.where(target: :model)
  end
end
