module Memberships
  class UpdateRoles
    def initialize(challenge:)
      @challenge = challenge
    end

    def call
      @challenge.memberships.includes(:user, challenge: :access_rules).each do |membership|
        update_membership_status(membership)
      end
    end

  private
    def update_membership_status(membership)
      user = membership.user

      unless membership.satisfies_access_rules?
        membership.destroy
        return
      end

      new_role = @challenge.role_for(user)

      unless membership.has_role?(new_role)
        membership.update!(roles: [ new_role ])
      end
    end
  end
end
