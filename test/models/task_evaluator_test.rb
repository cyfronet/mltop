require "test_helper"

class TaskEvaluatorTest < ActiveSupport::TestCase
  test "#evaluator_compatibility validation" do
    task = tasks(:st) # audio, text

    wrong_input = build(:evaluator, from: "video")
    assert_equal false, TaskEvaluator.new(task:, evaluator: wrong_input).valid?

    wrong_output = build(:evaluator, to: "video")
    assert_equal false, TaskEvaluator.new(task:, evaluator: wrong_output).valid?

    wrong_both = build(:evaluator, from: "video", to: "video")
    assert_equal false, TaskEvaluator.new(task:, evaluator: wrong_both).valid?

    correct_input = build(:evaluator, from: "audio")
    assert TaskEvaluator.new(task:, evaluator: correct_input).valid?

    correct_output = build(:evaluator, to: "text")
    assert TaskEvaluator.new(task:, evaluator: correct_output).valid?
  end
end
