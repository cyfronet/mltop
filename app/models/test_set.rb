require "zip"

class TestSet < ApplicationRecord
  belongs_to :challenge
  has_many :task_test_sets, dependent: :destroy
  has_many :entries, source: :test_set_entries, through: :task_test_sets do
    def for_task(task)
      where("task_test_sets.task_id = ?", task.id)
    end
  end
  has_many :tasks, -> { distinct }, through: :task_test_sets

  has_rich_text :description

  validates :name, presence: true

  scope :published, -> { where(published: true) }

  accepts_nested_attributes_for :task_test_sets

  def source_languages_for(task:)
    entries.for_task(task).pluck(:source_language).uniq.sort
  end

  def target_languages_for(task:)
    entries.for_task(task).pluck(:target_language).uniq.sort
  end

  def entry_language_for(source:, target:, task:)
    entries.for_task(task).detect { |e| e.source_language == source && e.target_language == target }
  end

  def to_s
    name
  end
end
