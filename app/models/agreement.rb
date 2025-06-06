class Agreement < ApplicationRecord
  belongs_to :consent
  delegated_type :agreementable, types: %w[ Membership Model ]

  validate :agreed_when_required

  def agreed_when_required
    errors.add(:agreed, :required) if consent.required && !agreed
  end
end
