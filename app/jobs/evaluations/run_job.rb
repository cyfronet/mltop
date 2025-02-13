module Evaluations
  class RunJob < ApplicationJob
    def perform(evaluations:, user:)
      evaluations.map { |evaluation| evaluation.run(user) }
    end
  end
end
