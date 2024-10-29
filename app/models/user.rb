class User < ApplicationRecord
  include RoleModel

  encrypts :ssh_key, :ssh_certificate
  has_many :models, inverse_of: :owner, dependent: :destroy

  roles :admin

  def credentials_valid?
    ssh_credentials.valid?
  end

  private
    def ssh_credentials
      Plgrid::SshCredentials.new(ssh_key, ssh_certificate)
    end
end
