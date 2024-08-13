require "zip"

class TestSet < ApplicationRecord
  has_many :entries, class_name: "TestSetEntry", dependent: :destroy do
    def for_task(task)
      where(task:)
    end
  end
  has_many :tasks, -> { distinct }, through: :entries

  has_rich_text :description

  validates :name, presence: true

  def source_languages
    @source_languages = entries.map(&:source_language).uniq.sort
  end

  def target_languages
    @target_languages = entries.map(&:target_language).uniq.sort
  end

  def entry_for_language(source, target)
    entries.detect { |e| e.source_language == source && e.target_language == target }
  end

  def all_inputs_zip_path(task)
    tmp_dir = Dir.mktmpdir
    Zip::File.open("#{tmp_dir}.zip", Zip::File::CREATE) do |zf|
      entries.where(task:).preload(:input_blob).with_attached_input.each do |entry|
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
