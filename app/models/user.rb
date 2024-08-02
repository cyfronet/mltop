class User < ApplicationRecord
  include RoleModel

  encrypts :ssh_key, :ssh_certificate
  has_many :models, inverse_of: :owner, dependent: :destroy

  roles :admin

  def self.from_plgrid_omniauth(auth)
    find_or_initialize_by(uid: auth.uid).tap do |user|
      user.attributes = {
        name: auth.info["name"], email: auth.info["email"],
        plgrid_login: auth.info["nickname"]
      }
      user.fetch_short_lived_ssh_credentials!(auth.dig("credentials", "token"))
    end
  end


  def fetch_short_lived_ssh_credentials!(token)
    ccm = Plgrid::Ccm.new(token)
    ccm.fetch!

    self.ssh_key = ccm.key
    self.ssh_certificate = ccm.certificate
  rescue
    Rails.logger.warn "Unable to fetch #{name} user ssh credentials"
  end
end
