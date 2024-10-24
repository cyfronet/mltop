# frozen_string_literal: true

module Evaluations
  class UpdateStatusJob < ApplicationJob
    def perform(user, host)
      @user = user
      @host = host
      return if submitted_evaluations.empty?

      response = check_statuses(user)
      case
      when response.success? then update_evaluations(response.statuses)
      when response.timeout? then log_error(user, :timeout, response.message)
      else log_error(user, :internal)
      end
    end

    private
    def submitted_evaluations
      @submitted_evaluations ||= Evaluation.joins(:evaluator, hypothesis: :model)
        .where(
          hypothesis: { models: { owner: @user } },
          evaluations: { status: [ :pending, :running ] },
          evaluator: { host: @host }
        )
    end

    def update_evaluations(statuses)
      statuses = statuses.transform_keys(&:to_s)
      submitted_evaluations.each do |evaluation|
        evaluation.update job_status: statuses[evaluation.job_id]
      end
    end

    def log_error(user, code, message)
      Rails.logger.tagged(self.class.name) do
        Rails.logger.warn(
          "Error while updating evaluations for #{user.plgrid_login}: #{code} #{message}"
        )
      end
    end

    def client
      @client ||= Mltop.hpc_client(@user, @host)
    end

    def check_statuses(user)
      Hpc::Response.new(request: client.jobs)
    end
  end
end
