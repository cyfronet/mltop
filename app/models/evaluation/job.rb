class Evaluation::Job
  include LinkHelper
  GROUP_DIR = "/net/pr2/projects/plgrid/plggmeetween/mltop"

  def initialize(evaluation, creator, runner)
    @evaluation = evaluation
    @creator = creator
    @runner = runner
  end

  def submit
    new_token = @evaluation.reset_token!
    submission = Hpc::Response.new(request: client.submit(script(new_token)))

    if submission.success?
      @evaluation.update(status: :pending, job_id: submission.job_id, creator: @creator)
    else
      @evaluation.update(status: :failed)
    end
    submission
  end

  private
    def client
      @client ||= Mltop.hpc_client(@creator, @evaluation.evaluator.host, @runner)
    end

    def script(new_token)
      HPCKit::Slurm::Script.new(@evaluation.evaluator.script, options(new_token))
    end

    def options(new_token)
      {
        current_working_directory: GROUP_DIR,
        environment: [
          "INPUT_URL=#{url_for(input)}",
          "GROUNDTRUTH_URL=#{url_for(groundtruth)}",
          "HYPOTHESIS_URL=#{url_for(hypothesis)}",
          internal.attached? ? "INTERNAL_URL=#{url_for(internal)}" : nil,
          "RESULTS_URL=#{results_upload_url}",
          "SOURCE_LANGUAGE=#{source}",
          "TARGET_LANGUAGE=#{target}",
          "TOKEN=#{new_token}"
        ].compact
      }
    end

    def input
      @evaluation.hypothesis.test_set_entry.input
    end

    def groundtruth
      @evaluation.hypothesis.test_set_entry.groundtruth
    end

    def hypothesis
      @evaluation.hypothesis.input
    end

    def internal
      @evaluation.hypothesis.test_set_entry.internal
    end

    def results_upload_url
      evaluation_scores_url(@evaluation)
    end

    def source
      @evaluation.hypothesis.test_set_entry.source_language
    end

    def target
      @evaluation.hypothesis.test_set_entry.target_language
    end
end
