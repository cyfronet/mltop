class AccessRule < ApplicationRecord
  belongs_to :challenge

  validates :group_name, presence: true, uniqueness: { scope: :challenge_id }
end
