class TaskTestSet < ApplicationRecord
  belongs_to :test_set
  belongs_to :task
  has_many :test_set_entries, class_name: "TestSetEntry", dependent: :destroy

  has_rich_text :description

  validates :test_set, uniqueness: { scope: :task }
end
