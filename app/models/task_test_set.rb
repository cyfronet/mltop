class TaskTestSet < ApplicationRecord
  belongs_to :test_set
  belongs_to :task

  has_rich_text :description

  validates :test_set, uniqueness: { scope: :task }
end
