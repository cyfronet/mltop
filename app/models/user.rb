class User < ApplicationRecord
  include RoleModel
  include Users::Contribution

  encrypts :ssh_key, :ssh_certificate
  has_many :models, inverse_of: :owner, dependent: :destroy
  has_many :evaluations, class_name: "Evaluation", foreign_key: "creator_id"

  roles :admin, :meetween_member

  scope :external, -> { where(without_role(:meetween_member)) }

  validates :email, presence: true

  def credentials_valid?
    ssh_credentials.valid?
  end

  def has_hypotheses?
    models.map(&:hypothesis).flatten.any?
  end
  private
    def ssh_credentials
      Plgrid::SshCredentials.new(ssh_key, ssh_certificate)
    end

    def self.without_role(*roles)
      (arel_table[:roles_mask] & mask_for(roles)).eq(0)
    end
end
