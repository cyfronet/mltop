require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "#with_published_test_sets" do
    st = Task.with_published_test_sets.find(tasks(:st).id)

    assert_equal test_sets(:flores, :mustc), st.test_sets.to_a
  end

  test ".compatible_evaluators" do
    task = tasks(:st) # audio, text

    create(:evaluator, from: "audio", to: "video")
    create(:evaluator, from: "audio", to: nil)
    matching_evaluators = [
      create(:evaluator, from: "audio", to: "text"),
      create(:evaluator, from: nil, to: "text")
    ]

    assert_equal matching_evaluators, task.compatible_evaluators
  end
end
