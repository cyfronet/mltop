class Current < ActiveSupport::CurrentAttributes
  attribute :user, :challenge, :membership

  def user=(user)
    super
    find_membership
  end

  def challenge=(challenge)
    super
    find_membership
  end

  def challenge_member?
    membership.present?
  end

  def scoring_released?
    challenge.visibility.present?
  end

  def challenge_manager?
    membership&.has_role?(:manager)
  end

  def challenge_owner?
    challenge.owner_id == user.id
  end

  private

  def find_membership
    self.membership = Membership.find_by(user:, challenge:) if user && challenge
  end
end
