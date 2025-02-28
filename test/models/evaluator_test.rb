require "test_helper"

class EvaluatorTest < ActiveSupport::TestCase
  test ".mathcing_task" do
    task = tasks(:st) # audio, text

    create(:evaluator, input_modality: "audio", output_modality: "video")
    create(:evaluator, input_modality: "audio", output_modality: nil)
    matching_evaluators = [
      create(:evaluator, input_modality: "audio", output_modality: "text"),
      create(:evaluator, input_modality: nil, output_modality: "text")
    ]

    assert_equal matching_evaluators, Evaluator.matching_task(task)
  end
end
