class Groundtruth < ApplicationRecord
  LANGUAGES = %w[be bg bs ca cs da de el en en es et fi fr ga gl hr hu is it lb lt lv mk mt nl no pl pr pt ro ru sk sl sr sv th tr uk]

  belongs_to :test_set_entry
  belongs_to :task
  has_many :hypotheses, dependent: :destroy

  has_one_attached :input

  validates :language, presence: true, uniqueness: { scope: :test_set_entry },
  inclusion: { in: LANGUAGES, message: "%{value} is not a correct language code" }
  validates :test_set_entry, uniqueness: { scope: :subtask_id }
  validate :attached_input

  def attached_input
    errors.add :base, "File has to be attached" unless input.attached?
  end

  def to_s
    "#{test_set_entry.language}->#{language}"
  end
end
