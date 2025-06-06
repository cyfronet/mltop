class Agreement < ApplicationRecord
  belongs_to :consent
  delegated_type :agreementable, types: %w[ Membership Model ]

  validate :agreed_when_mandatory

  def agreed_when_mandatory
    errors.add(:agreed, "This consent is required") if consent.mandatory && !agreed
  end
end
