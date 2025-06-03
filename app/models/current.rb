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

  private

  def find_membership
    self.membership = Membership.find_by(user:, challenge:) if user && challenge
  end
end
