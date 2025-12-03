class Site < ApplicationRecord
  validates :name, :host, presence: true, uniqueness: true
end
