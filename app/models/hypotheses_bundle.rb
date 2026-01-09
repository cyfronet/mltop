class HypothesesBundle < ApplicationRecord
  has_one_attached :archive
  belongs_to :model
  has_many :hypotheses, dependent: :nullify

  validates :archive, presence: true

  enum :state, { processing: "processing", failed: "failed", success: "success" }, default: "processing"

  after_initialize :generate_name, if: :new_record?

  def process_later
    HypothesesBundles::ProcessJob.perform_later(self)
  end

  def process_now
    HypothesesBundles::Processor.new(self).process
  end

  private
    def generate_name
      self.name ||= "#{model.name} #{I18n.l(Time.current, format: :compact)}"
    end
end
