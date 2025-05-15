module Evaluations
  class RunJob < ApplicationJob
    def perform(evaluations:, user:)
      evaluations.group_by { |evaluation| evaluation.evaluator.host }.map do |host, evaluations|
        backend = HPCKit::Slurm::Backends::Netssh.new(
          host, user.plgrid_login,
          key_data: [ user.ssh_key ], keycert_data: [ user.ssh_certificate ], keys_only: true
        )
        connection = HPCKit::Slurm::Restd.new(backend)
        connection.start do |restd_runner|
          evaluations.map { |evaluation| evaluation.run(user, restd_runner) }
        end
      end
    end
  end
end
