class Evaluation < ApplicationRecord
  include Tokenable
  include LinkHelper
  GROUP_DIR = "/net/pr2/projects/plgrid/plggmeetween/mltop"

  belongs_to :evaluator
  belongs_to :hypothesis, touch: true
  belongs_to :creator, class_name: "User", optional: true

  has_many :metrics, through: :evaluator
  has_many :scores, dependent: :destroy

  validates :hypothesis, uniqueness: { scope: :evaluator_id }

  broadcasts_to ->(ev) { [ ev.hypothesis.model, ev.hypothesis.test_set_entry.task ] },
                partial: "submissions/evaluations/evaluation"

  after_update :broadcast_scores
  after_create_commit :broadcast_scores

  def broadcast_scores
    broadcaster.broadcast_scores
  end

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
    new_token = reset_token!
    request = submit_script(user, new_token, restd_runner)

    if request.success?
      update(status: :pending, job_id: request.job_id, creator: user)
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

    def submit_script(user, new_token, restd_runner)
      Hpc::Response.new(request: client(user, restd_runner).submit(script(new_token)))
    end

    def client(user, restd_runner)
      @client ||= Mltop.hpc_client(user, evaluator.host, restd_runner)
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
          hypothesis.test_set_entry.internal.attached? ? "INTERNAL_URL=#{url_for(hypothesis.test_set_entry.internal)}" : nil,
          "RESULTS_URL=#{evaluation_scores_url(self)}",
          "SOURCE_LANGUAGE=#{hypothesis.test_set_entry.source_language}",
          "TARGET_LANGUAGE=#{hypothesis.test_set_entry.target_language}",
          "TOKEN=#{new_token}"
        ].compact
      }
    end

    def broadcaster
      @broadcaster ||= Evaluations::Broadcaster.new(self)
    end
end
