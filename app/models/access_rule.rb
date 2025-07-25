class AccessRule < ApplicationRecord
  belongs_to :challenge

  validates_presence_of :group_name
end
