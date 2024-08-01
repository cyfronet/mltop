class Groundtruth < ApplicationRecord
  belongs_to :test_set_entry
  belongs_to :task
  has_many :hypotheses, dependent: :destroy

  has_one_attached :input

  validates :language, presence: true, uniqueness: { scope: :test_set_entry },
  inclusion: { in: Mltop::LANGUAGES, message: "%{value} is not a correct language code" }
  validate :attached_input

  def attached_input
    errors.add :base, "File has to be attached" unless input.attached?
  end

  def to_s
    "#{test_set_entry.language}->#{language}"
  end
end
