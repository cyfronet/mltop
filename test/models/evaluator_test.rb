require "test_helper"

class EvaluatorTest < ActiveSupport::TestCase
  test ".mathcing_task" do
    task = tasks(:st) # audio, text

    create(:evaluator, from: "audio", to: "video")
    create(:evaluator, from: "audio", to: nil)
    matching_evaluators = [
      create(:evaluator, from: "audio", to: "text"),
      create(:evaluator, from: nil, to: "text")
    ]

    assert_equal matching_evaluators, Evaluator.matching_task(task)
  end
end
