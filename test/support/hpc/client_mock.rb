class Hpc::ClientMock
  def self.for(user, host, restd_runner = nil)
    new()
  end

  def initialize
  end

  def jobs
  end

  def submit
  end

  class << self
    def stub_jobs(job_ids, code: "200", body: nil)
      body ||= {
        "jobs": job_ids.map do |job_id|
          { job_id: job_id, "job_state": "RUNNING" }
        end
      }.to_json
      Hpc::ClientMock.any_instance.stubs(:jobs).returns(
        RequestMock.new(code:, body:)
      )
    end

    def stub_submit(code: "200", body: nil)
      body ||= {
        "result": {
          "job_id": "1"
        }
      }.to_json
      Hpc::ClientMock.any_instance.stubs(:submit).returns(
        RequestMock.new(code:, body:)
      )
    end
  end

  private

    class RequestMock
      def initialize(code:, body:)
        @code = code
        @body = body
      end

      attr_reader :code, :body
    end
end
