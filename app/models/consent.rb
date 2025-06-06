class Consent < ApplicationRecord
  belongs_to :challenge

  TARGETS = { challenge: "challenge", model: "model" }
  enum :target, TARGETS, prefix: true

  validates :description, :target, presence: true
end
