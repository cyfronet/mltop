class Consent < ApplicationRecord
  belongs_to :challenge

  TARGETS = { challenge: "challenge", model: "model" }
  enum :target, TARGETS, suffix: "scoped"

  has_rich_text :description

  validates :name, :target, presence: true
end
