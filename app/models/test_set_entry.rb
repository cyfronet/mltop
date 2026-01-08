class TestSetEntry < ApplicationRecord
  belongs_to :task_test_set, touch: true
  has_one :test_set, through: :task_test_set
  has_one :task, through: :task_test_set

  has_many :hypotheses, dependent: :destroy

  has_one_attached :input
  has_one_attached :internal
  has_one_attached :groundtruth

  validates :input, presence: true
  validates :groundtruth, presence: true

  validates :source_language, presence: true,
    inclusion: { in: Mltop::LANGUAGES, message: "%{value} is not a correct language code" }

  validates :target_language, presence: true,
    inclusion: { in: Mltop::LANGUAGES, message: "%{value} is not a correct language code" }

  def input_file_name
    return unless input_blob

    ext = File.extname(input_blob.filename.to_s)
    "#{test_set.name}--#{source_language}-#{target_language}#{ext}"
  end

  def name
    soruce_language.concat(test_set.name)
  end

  def to_s = "#{source_language} → #{target_language}"
end
