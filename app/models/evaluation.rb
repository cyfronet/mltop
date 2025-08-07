class Evaluation < ApplicationRecord
  include Tokenable

  belongs_to :evaluator
  belongs_to :hypothesis, touch: true
  belongs_to :creator, class_name: "User", optional: true

  has_many :metrics, through: :evaluator
  has_many :scores, dependent: :destroy

  validates :hypothesis, uniqueness: { scope: :evaluator_id }

  broadcasts_to ->(ev) { [ ev.hypothesis.model, ev.hypothesis.test_set_entry.task ] },
                partial: "challenges/submissions/evaluations/evaluation"

  enum :status, {
    created: 0,
    pending: 1,
    running: 2,
    completed: 3,
    failed: 4
  }

  def record_scores!(values)
    transaction do
      metrics.each do |metric|
        scores.create! metric:, value: values[metric.name]&.to_f
      end
      update! status: :completed, token: nil
    end
  end

  def record_error!(error_message)
    update! status: :failed, error_message:, token: nil
  end

  def score_for_metric(metric)
    scores.detect { |s| s.metric_id == metric.id } ||
      Score.new(evaluation: self, metric:)
  end

  def run_later(user)
    Evaluations::RunJob.perform_later(evaluations: [ self ], user:)
  end

  def run(user, restd_runner = nil)
    Evaluation::Job.new(self, user, restd_runner).submit
  end

  def job_status=(new_status)
    status = new_status&.downcase.presence_in(self.class.statuses.keys) || "failed"
    status = "failed" if status == "completed" && scores.size.zero?

    self.status = status
    self.token = nil if finished_status?(status)
  end

  def active?
    pending? || running?
  end

  private
    def finished_status?(status)
      %w[ completed failed ].include?(status.to_s)
    end
end
