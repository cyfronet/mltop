class Model < ApplicationRecord
  belongs_to :owner, class_name: "User"
  belongs_to :challenge

  has_many :task_models, dependent: :destroy
  has_many :tasks, through: :task_models
  accepts_nested_attributes_for :tasks, allow_destroy: true

  has_many :hypothesis, dependent: :destroy

  has_rich_text :description

  validates :name, presence: true
  validates :task_ids, presence: true

  scope :external, -> { where(owner: User.external) }

  scope :with_not_evaluated_hypothesis, -> do
    includes(hypothesis: :evaluations)
      .where.not(hypothesis: { id: nil })
      .where(hypothesis: { evaluations: { id: nil } })
  end

  def to_s
    name
  end
end
