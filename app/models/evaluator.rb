class Evaluator < ApplicationRecord
  KINDS = { automatic: "automatic", manual: "manual" }.freeze
  belongs_to :challenge
  belongs_to :site, required: false

  has_many :task_evaluators, dependent: :destroy
  has_many :tasks, through: :task_evaluators

  has_many :metrics, dependent: :destroy

  has_many :evaluations, dependent: :destroy

  enum :kind, KINDS
  enum :from, Task::TYPES, prefix: true
  enum :to, Task::TYPES, prefix: true

  delegate :host, to: :site

  before_create :set_default_kind
  validates :name, presence: true
  validates :script, :directory, presence: true, if: :automatic?
  def to_s = name

  private
    def set_default_kind
      self.kind ||= "automatic"
    end
end
