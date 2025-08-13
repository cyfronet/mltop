class Evaluation::Script < HPCKit::Slurm::Script
  include Rails.application.routes.url_helpers

  GROUP_DIR = "/net/pr2/projects/plgrid/plggmeetween/mltop"

  def initialize(evaluation, token)
    @evaluation = evaluation
    @token = token
    super(evaluation.evaluator.script, script_options)
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
      .merge(script_name: "/#{ChallengeSlug.encode(challenge.id)}")
  end

  private
    def script_options
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
          "TOKEN=#{@token}",
          "TASK=#{task.slug}"
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

    def task
      @evaluation.hypothesis.test_set_entry.task
    end

    def challenge
      Challenge.joins(models: :hypotheses).find_by(hypotheses: { id: @evaluation.hypothesis })
    end
end
