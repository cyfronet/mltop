class TestSetEntry < ApplicationRecord
  belongs_to :test_set
  has_many :groundtruths, dependent: :destroy

  has_one_attached :input

  validates :input, presence: true
  validates :language, presence: true, uniqueness: { scope: :test_set_id },
  inclusion: { in: Mltop::LANGUAGES, message: "%{value} is not a correct language code" }

  def input_file_name
    return unless input_blob

    ext = File.extname(input_blob.filename.to_s)
    "#{test_set.name}--#{language}#{ext}"
  end

  def name
    language.concat(test_set.name)
  end
end
