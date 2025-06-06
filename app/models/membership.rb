class Membership < ApplicationRecord
  include Agreementable

  belongs_to :user
  belongs_to :challenge
end
