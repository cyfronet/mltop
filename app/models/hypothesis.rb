class Hypothesis < ApplicationRecord
  belongs_to :model
  belongs_to :test_set_entry

  has_many :evaluations, dependent: :destroy

  has_one_attached :input

  validates :input, presence: true
  validates :test_set_entry, uniqueness: { scope: :model }

  def evaluate_missing!(creator)
    transaction do
      run_evaluators = evaluations.map(&:evaluator_id)
      missing_evaluations = evaluators
        .reject { |e| run_evaluators.include?(e.id) }
        .map do |evaluator|
          evaluations.build(evaluator:, creator:).tap { it.save! }
        end.compact

      Evaluations::RunJob
        .perform_later(evaluations: missing_evaluations, user: Current.user)
    end
  end

  def fully_evaluated?
    evaluations.size == evaluators.size
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
