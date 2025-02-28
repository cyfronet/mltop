require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "#matching_task_evaluator validation" do
    task = tasks(:st) # audio, text

    wrong_input = build(:evaluator, input_modality: "video")
    assert_equal false, TaskEvaluator.new(task:, evaluator: wrong_input).valid?

    wrong_output = build(:evaluator, output_modality: "video")
    assert_equal false, TaskEvaluator.new(task:, evaluator: wrong_output).valid?

    wrong_both = build(:evaluator, input_modality: "video", output_modality: "video")
    assert_equal false, TaskEvaluator.new(task:, evaluator: wrong_both).valid?

    correct_input = build(:evaluator, input_modality: "audio")
    assert TaskEvaluator.new(task:, evaluator: correct_input).valid?

    correct_output = build(:evaluator, output_modality: "text")
    assert TaskEvaluator.new(task:, evaluator: correct_output).valid?
  end
end
