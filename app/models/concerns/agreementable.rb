module Agreementable
  extend ActiveSupport::Concern

  included do
    has_many :agreements, as: :agreementable, dependent: :delete_all
    accepts_nested_attributes_for :agreements
  end
end
