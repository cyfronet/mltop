class Challenge < ApplicationRecord
  INTRODUCTION = YAML.load_file(File.join(Rails.root, "config", "challenges", "default_texts.yml"))["introduction"]
  CALL_TO_ACTION = YAML.load_file(File.join(Rails.root, "config", "challenges", "default_texts.yml"))["call_to_action"]
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
  has_rich_text :introduction
  has_rich_text :call_to_action

  has_one_attached :logo

  validates :name, :starts_at, :ends_at, presence: true
  validates :ends_at, comparison: { greater_than: :starts_at }

  VISIBILITIES = { leaderboard_released: "leaderboard_released", scores_released: "scores_released" }
  enum :visibility, VISIBILITIES

  before_create :set_default_texts

  def to_s = name

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

  def join!(user, agreements_attributes:)
    memberships.create!(user: user, roles: [ roles_manager.role_for(user) ],
                       agreements_attributes:)
  end

  def update_memberships
    roles_manager.update_memberships
  end

  def update_membership(membership)
    roles_manager.update_membership(membership)
  end

  private
    def roles_manager = Challenge::RolesManager.new(self)

    def set_default_texts
      self.introduction = INTRODUCTION if self.introduction.empty?
      self.call_to_action = CALL_TO_ACTION if self.call_to_action.empty?
    end
end
