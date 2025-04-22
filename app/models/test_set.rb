require "zip"

class TestSet < ApplicationRecord
  belongs_to :challenge, required: false

  has_many :entries, class_name: "TestSetEntry", dependent: :destroy do
    def for_task(task)
      where(task:)
    end
  end
  has_many :tasks, -> { distinct }, through: :entries

  has_rich_text :description

  validates :name, presence: true

  scope :published, -> { where(published: true) }

  def source_languages_for(task:)
    entries.where(task:).pluck(:source_language).uniq.sort
  end

  def target_languages_for(task:)
    entries.where(task:).pluck(:target_language).uniq.sort
  end

  def entry_language_for(source:, target:, task:)
    entries.detect { |e| e.source_language == source && e.target_language == target && e.task == task }
  end

  def to_s
    name
  end
end
