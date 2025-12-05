class Evaluation::Script < HPCKit::Slurm::Script
  def initialize(evaluation, token)
    @evaluation = evaluation
    @token = token
    super(evaluation.evaluator.script, script_options)
  end

  private
    def script_options
      {
        current_working_directory:,
        environment: [
          "INPUT_URL=#{blob_url(input)}",
          "GROUNDTRUTH_URL=#{blob_url(groundtruth)}",
          "HYPOTHESIS_URL=#{blob_url(hypothesis)}",
          internal.attached? ? "INTERNAL_URL=#{blob_url(internal)}" : nil,
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

    def source
      @evaluation.hypothesis.test_set_entry.source_language
    end

    def target
      @evaluation.hypothesis.test_set_entry.target_language
    end

    def task
      @evaluation.hypothesis.test_set_entry.task
    end

    def current_working_directory
      @evaluation.evaluator.directory
    end

    def challenge
      Challenge.joins(models: :hypotheses).find_by(hypotheses: { id: @evaluation.hypothesis })
    end

    def blob_url(blob)
      Rails.application.routes.url_helpers.rails_blob_url(blob, default_url_options)
    end

    def results_upload_url
      Rails.application.routes.url_helpers.evaluation_scores_url(@evaluation, default_url_options)
    end

    def default_url_options
      Rails.application.config.action_mailer.default_url_options
        .merge(script_name: "/#{ChallengeSlug.encode(challenge.id)}")
    end
end
