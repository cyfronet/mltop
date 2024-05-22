require "zip"

class TestSet < ApplicationRecord
  belongs_to :task

  has_many :subtask_test_sets, dependent: :destroy
  has_many :subtasks, through: :subtask_test_sets
  has_many :evaluations, through: :subtask_test_sets

  has_rich_text :description

  validates :name, presence: true

  def source_languages
    @source_languages ||= subtask_test_sets_cache.keys.map(&:first).uniq.sort
  end

  def target_languages
    @target_languages ||= subtask_test_sets_cache.keys.map(&:second).uniq.sort
  end

  def for_subtask(source_language, target_language)
    subtask_test_sets_cache[[ source_language, target_language ]]
  end

  def all_inputs_zip_path
    tmp_dir = Dir.mktmpdir
    Zip::File.open("#{tmp_dir}.zip", Zip::File::CREATE) do |zf|
      subtask_test_sets.preload(:subtask, :input_blob).with_attached_input.each do |subtask_test_set|
        filename = subtask_test_set.input_file_name

        File.open(File.join(tmp_dir, filename), "wb") do |file|
          subtask_test_set.input.download { |chunk| file.write(chunk) }
        end

        zf.add(filename, File.join(tmp_dir, filename))
      end
    end
    FileUtils.rm_rf(tmp_dir)

    "#{tmp_dir}.zip"
  end

  private
    def input_file_name(subtask_test_set)
      ext = File.extname(subtask_test_set.input_blob.filename)

      "#{name}--#{subtask_test_set.source_langugage}-to-#{subtask_test_set.target_language}#{ext}"
    end

    def subtask_test_sets_cache
      @subtask_test_sets_cache ||=
        subtask_test_sets.includes(:subtask).index_by do |sts|
          [ sts.subtask.source_language, sts.subtask.target_language ]
        end
    end
end
