module Sso
  class Google
    def self.from_omniauth(auth)
      new(auth)
    end

    def initialize(auth)
      @uid = auth.uid
      @name = auth.info["name"]
      @email = auth.info["email"]
    end

    def to_user
      if @uid
        User.find_or_initialize_by(provider: "google", uid: @uid).tap do |user|
          user.assign_attributes(attributes)
          user.save
        end
      end
    end

    private
      def attributes
        {
          name: @name,
          email: @email
        }
      end
  end
end
