class Evaluation::Job
  def initialize(evaluation, creator, runner)
    @evaluation = evaluation
    @creator = creator
    @runner = runner
  end

  def submit
    new_token = @evaluation.reset_token!
    submission = Hpc::Response.new(
      request: client.submit(Evaluation::Script.new(@evaluation, new_token)))

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
end
