class TestSet < ApplicationRecord
  belongs_to :task

  has_many :subtask_test_sets, dependent: :destroy
  has_many :subtasks, through: :subtask_test_sets
  has_many :evaluations, through: :subtask_test_sets

  has_rich_text :description

  validates :name, presence: true

  def from_languages
    %w[ en pl it ]
  end

  def to_languages
    %w[ en pl it ]
  end
end
