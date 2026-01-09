module HypothesesBundles
  class ProcessJob < ApplicationJob
    queue_as :default
    discard_on ActiveJob::DeserializationError

    def perform(hypotheses_bundle)
      hypotheses_bundle.process_now
    end
  end
end
