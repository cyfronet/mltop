class Evaluation < ApplicationRecord
  include Tokenable
  include LinkHelper
  GROUP_DIR = "/net/pr2/projects/plgrid/plggmeetween/mltop"

  belongs_to :evaluator
  belongs_to :hypothesis

  has_many :metrics, through: :evaluator
  has_many :scores, dependent: :destroy

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
    end
  end

  def submit(user)
    new_token = reset_token!
    request = client(user).submit(script(new_token))
    if request.class == Net::HTTPOK
      update(status: :pending, job_id: JSON.parse(request.body)["result"]["job_id"])
    else
      update(status: :failed)
    end
    request
  end

  private

  def client(user)
    @client ||= ::Hpc::Client.for(user, evaluator.host)
  end

  def script(new_token)
    HPCKit::Slurm::Script.new(evaluator.script, options(new_token))
  end

  def options(new_token)
    {
      current_working_directory: GROUP_DIR,
      environment: {
        GROUNDTRUTH_URL: url_for(hypothesis.test_set_entry.groundtruth),
        HYPOTHESIS_URL: url_for(hypothesis.input),
        RESULTS_URL: evaluation_scores_url(self),
        SOURCE_LANGUAGE: hypothesis.test_set_entry.source_language,
        TARGET_LANGUAGE: hypothesis.test_set_entry.target_language,
        TOKEN: new_token
      }
    }
  end
end
