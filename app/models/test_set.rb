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

  def to_s
    "#{name}"
  end
end
