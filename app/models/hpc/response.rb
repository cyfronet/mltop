# frozen_string_literal: true

class Hpc::Response
  def initialize(request:)
    @request_status = request.code.to_i
    @message = parse(request.body)
  end

  def success?
    request_status.between?(200, 299)
  end

  def error?
    request_status >= 400
  end

  def timeout?
    request_status == 422
  end

  def job_id
    message["result"]["job_id"]
  end

  def statuses
    message["jobs"].map { |job| [ job["job_id"], job["job_state"] ] }.to_h
  end

  attr_reader :message

  private
    attr_reader :request_status

    def parse(body)
      JSON.parse(body)
    rescue JSON::ParserError
      body
    end
end
