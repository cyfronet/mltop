  class Hpc::Client
    def self.for(user, host)
      backend = HPCKit::Slurm::Backends::Netssh.new(
        host, user.plgrid_login,
        key_data: [ user.ssh_key ], keycert_data: [ user.ssh_certificate ], keys_only: true
      )
      connection = HPCKit::Slurm::Restd.new(backend)
      HPCKit::Slurm::Client.new(connection)
    end
  end
