class User < ApplicationRecord
  include RoleModel
  include Users::Contribution

  attribute :groups, :string, array: true, default: []

  encrypts :ssh_key, :ssh_certificate
  has_many :models, inverse_of: :owner, dependent: :destroy
  has_many :evaluations, class_name: "Evaluation", foreign_key: "creator_id"
  has_many :challenges, inverse_of: :owner, dependent: :destroy
  has_many :memberships, dependent: :destroy

  roles :admin

  scope :external, -> do
    joins(:memberships)
      .where(Membership.without_role(:manager))
  end

  def credentials_valid?
    ssh_credentials.valid?
  end

  def has_hypotheses?
    models.map(&:hypotheses).flatten.any?
  end

  def from_plgrid?
    provider == "plgrid"
  end

  private
    def ssh_credentials
      Plgrid::SshCredentials.new(ssh_key, ssh_certificate)
    end
end
