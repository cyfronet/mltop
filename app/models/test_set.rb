require "zip"

class TestSet < ApplicationRecord
  has_many :task_test_sets, dependent: :destroy
  has_many :tasks, through: :task_test_sets

  has_many :entries, class_name: "TestSetEntry", dependent: :destroy
  has_many :groundtruths, through: :entries

  has_rich_text :description

  validates :name, presence: true

  def languages
    @languages = entries.map(&:language)
  end

  def entry_for_language(language)
    entries.detect { |e| e.language == language }
  end

  def all_inputs_zip_path
    tmp_dir = Dir.mktmpdir
    Zip::File.open("#{tmp_dir}.zip", Zip::File::CREATE) do |zf|
      entries.preload(:input_blob).with_attached_input.each do |entry|
        if filename = entry.input_file_name
          File.open(File.join(tmp_dir, filename), "wb") do |file|
            entry.input.download { |chunk| file.write(chunk) }
          end

          zf.add(filename, File.join(tmp_dir, filename))
        end
      end
    end
    FileUtils.rm_rf(tmp_dir)

    "#{tmp_dir}.zip"
  end

  def to_s
    "#{name}"
  end
end
