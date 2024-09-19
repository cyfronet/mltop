class Hypothesis < ApplicationRecord
  belongs_to :model
  belongs_to :test_set_entry

  has_many :evaluations, dependent: :destroy

  has_one_attached :input

  validates :input, presence: true
  validates :test_set_entry, uniqueness: { scope: :model }

  def evaluate!
    transaction do
      evaluations = test_set_entry.task.evaluators.map do |evaluator|
        evaluator.evaluations.build(hypothesis: self).tap { |evaluation| evaluation.save! }
      end.compact
      Evaluations::RunJob.perform_later(evaluations:, user: Current.user)
    end
  end

  def self.owned_by(user)
    joins(:model).where(models: { owner: Current.user })
  end

  def self.has_evaluations_by_entry
    left_joins(:evaluations)
    .pluck("test_set_entry_id, hypotheses.id, evaluations.id")
    .group_by(&:first).transform_values do |data|
      { hypothesis_id: data[0][1], has_evaluations: data.present? }
    end
  end
end
