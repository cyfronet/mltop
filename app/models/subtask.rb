class Subtask < ApplicationRecord
  belongs_to :task

  has_many :subtask_test_sets, dependent: :destroy

  with_options presence: true do
    validates :name
    validates :source_language
    validates :target_language
  end
end
