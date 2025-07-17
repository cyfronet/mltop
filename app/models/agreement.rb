class Agreement < ApplicationRecord
  belongs_to :consent
  delegated_type :agreementable, types: %w[ Membership Model ]

  validates :agreed, acceptance: true, if: :mandatory?

  def mandatory? = consent.mandatory
end
