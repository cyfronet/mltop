class ModelType < ApplicationRecord
  TYPES = { movie: "movie", text: "text" }

  with_options presence: true do
    validates :name
    validates :from
    validates :to
  end

  enum from: TYPES, _prefix: true
  enum to: TYPES, _prefix: true
end
