class ChallengeTestSetEntry < ApplicationRecord
  belongs_to :test_set_entry, required: true
  belongs_to :challenge, required: true
end
