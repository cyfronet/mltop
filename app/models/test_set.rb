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

  private
    def subtask_test_sets_cache
      @subtask_test_sets_cache ||=
        subtask_test_sets.includes(:subtask).index_by do |sts|
          [ sts.subtask.source_language, sts.subtask.target_language ]
        end
    end
end
