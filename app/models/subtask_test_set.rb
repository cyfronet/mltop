class SubtaskTestSet < ApplicationRecord
  belongs_to :subtask
  belongs_to :test_set

  has_one_attached :input
  has_one_attached :reference

  has_many :evaluations, dependent: :destroy

  validates :test_set, uniqueness: { scope: :subtask_id }

  def input_file_name
    return unless input_blob

    ext = File.extname(input_blob.filename.to_s)
    "#{test_set.name}--#{subtask.source_language}-to-#{subtask.target_language}#{ext}"
  end
end
