class User < ApplicationRecord
  include RoleModel
  include User::Contribution

  encrypts :ssh_key, :ssh_certificate
  has_many :models, inverse_of: :owner, dependent: :destroy

  roles :admin, :meetween_member

  scope :external, -> { where(without_role(:meetween_member)) }

  def credentials_valid?
    ssh_credentials.valid?
  end

  private
    def ssh_credentials
      Plgrid::SshCredentials.new(ssh_key, ssh_certificate)
    end

    def self.without_role(*roles)
      (arel_table[:roles_mask] & mask_for(roles)).eq(0)
    end
end
