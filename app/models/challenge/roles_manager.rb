class Challenge::RolesManager
  def initialize(challenge)
    @challenge = challenge
  end

  def update_memberships
    @challenge.transaction do
      @challenge.memberships.includes(:user, challenge: :access_rules).each do |membership|
        update_membership_status(membership)
      end
    end
  end

private
  def update_membership_status(membership)
    if membership.valid?
      new_role = @challenge.role_for(membership.user)

      unless membership.has_role?(new_role)
        membership.update(roles: [ new_role ])
      end
    else
      membership.destroy
    end
  end
end
