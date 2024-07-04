class Evaluation < ApplicationRecord
  belongs_to :evaluator
  belongs_to :hypothesis

  has_many :scores, dependent: :destroy
end
