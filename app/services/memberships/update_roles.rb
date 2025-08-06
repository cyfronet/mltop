module Memberships
  class UpdateRoles
    def initialize(challenge:)
      @challenge = challenge
    end

    def call
      @challenge.memberships.includes(user: :groups).each do |membership|
        update_membership_status(membership)
      end
    end

  private
    def update_membership_status(membership)
      user = membership.user

      unless @challenge.can_be_joined_by?(user)
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
