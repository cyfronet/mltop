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

  def update_membership(membership)
    update_membership_status(membership)
  end

  def role_for(user)
    owner?(user) || manager_role?(user) ? :manager : :participant
  end

private
  def update_membership_status(membership)
    if membership.valid?
      new_role = role_for(membership.user)

      unless membership.has_role?(new_role)
        membership.update(roles: [ new_role ])
      end
    else
      membership.destroy
    end
  end

  def owner?(user)
    user.id == @challenge.owner_id
  end

  def manager_role?(user)
    (user.groups & manager_groups.map(&:group_name)).any?
  end

  def manager_groups
    @challenge.access_rules.management
  end
end
