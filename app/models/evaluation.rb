class Evaluation < ApplicationRecord
  include Tokenable
  include LinkHelper
  GROUP_DIR = "/net/pr2/projects/plgrid/plggmeetween/mltop"

  belongs_to :evaluator
  belongs_to :hypothesis, touch: true

  has_many :metrics, through: :evaluator
  has_many :scores, dependent: :destroy

  validates :hypothesis, uniqueness: { scope: :evaluator_id }

  broadcasts_to ->(ev) { [ ev.hypothesis.model, ev.hypothesis.test_set_entry.task ] },
                partial: "submissions/evaluations/evaluation"

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

  def run(user)
    new_token = reset_token!
    request = submit_script(user, new_token)

    if request.success?
      update(status: :pending, job_id: request.job_id)
    else
      update(status: :failed)
    end
    request
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

    def submit_script(user, new_token)
      Hpc::Response.new(request: client(user).submit(script(new_token)))
    end

    def client(user)
      @client ||= Mltop.hpc_client(user, evaluator.host)
    end

    def script(new_token)
      HPCKit::Slurm::Script.new(evaluator.script, options(new_token))
    end

    def options(new_token)
      {
        current_working_directory: GROUP_DIR,
        environment: [
          "INPUT_URL=#{url_for(hypothesis.test_set_entry.input)}",
          "GROUNDTRUTH_URL=#{url_for(hypothesis.test_set_entry.groundtruth)}",
          "HYPOTHESIS_URL=#{url_for(hypothesis.input)}",
          "RESULTS_URL=#{evaluation_scores_url(self)}",
          "SOURCE_LANGUAGE=#{hypothesis.test_set_entry.source_language}",
          "TARGET_LANGUAGE=#{hypothesis.test_set_entry.target_language}",
          "TOKEN=#{new_token}"
        ]
      }
    end
end
