require "ostruct"

module Plgrid
  class User
    def self.from_omniauth(auth)
      new(auth)
    end

    attr_reader :uid

    def initialize(auth)
      @uid = auth.uid
      @teams= auth.dig("extra", "raw_info", "groups") || []
      @name = auth.info["name"]
      @email = auth.info["email"]
      @plgrid_login = auth.info["nickname"]

      if meetween_member?
        fetch_short_lived_ssh_credentials!(auth.dig("credentials", "token"))
      end
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

    def to_user
      if uid
        ::User.find_or_initialize_by(uid:).tap do |user|
          meetween_member? ? user.roles.add(:meetween_member) : user.roles.delete(:meetween_member)
          user.assign_attributes(attributes)
          user.save
        end
      end
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
