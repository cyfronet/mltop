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

  def evaluators
    @evaluators ||= test_set_entry.task.evaluators
  end

  def evaluation_for(evaluator)
    evaluations.detect { |e| e.evaluator_id == evaluator.id } ||
      Evaluation.new(evaluator:, hypothesis: self)
  end

  def evaluations?
    evaluations.size.positive?
  end

  def self.owned_by(user)
    joins(:model).where(models: { owner: user })
  end
end
