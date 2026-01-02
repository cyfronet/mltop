class GroupSubmission < ApplicationRecord
  has_one_attached :file
  belongs_to :user
  belongs_to :challenge
  belongs_to :model
  has_many :hypotheses, dependent: :destroy

  validates :file, presence: true

  enum :state, { processing: "processing", failed: "failed", success: "success" }, default: "processing"
  def process_later
    GroupSubmissions::ProcessJob.perform_later(id)
  end
end
