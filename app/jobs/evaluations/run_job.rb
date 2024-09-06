module Evaluations
  class RunJob < ApplicationJob
    def perform(evaluations:, user:)
      evaluations.map { |evaluation| evaluation.submit(user) }
    end
  end
end
