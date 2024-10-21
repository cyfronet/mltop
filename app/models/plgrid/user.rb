require "ostruct"

module Plgrid
  class User
    def self.from_omniauth(auth)
      new(auth)
    end

    attr_reader :uid

    def initialize(auth)
      fetch_short_lived_ssh_credentials!(auth.dig("credentials", "token"))
      @uid = auth.uid
      @teams= auth.dig("extra", "raw_info", "groups") || []
      @name = auth.info["name"]
      @email = auth.info["email"]
      @plgrid_login = auth.info["nickname"]
    end

    def meetween_member?
      @teams.include?("plggmeetween")
    end

    def attributes
      {
        name: @name,
        email: @email,
        plgrid_login: @plgrid_login,
        ssh_key: @ssh_key,
        ssh_certificate: @ssh_certificate
      }
    end

    private
    def fetch_short_lived_ssh_credentials!(token)
      ccm = Plgrid::Ccm.new(token)
      ccm.fetch!

      @ssh_key =  ccm.key
      @ssh_certificate = ccm.certificate
    end
  end
end
