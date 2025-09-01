require "test_helper"

class ModelTest < ActiveSupport::TestCase
  test "score needs to be within strict metric range" do
    score = build(:score, value: 120)
    assert_not score.valid?
    score.value = -10
    assert_not score.valid?
    score.value = 10
    assert score.valid?
  end

  test "score doesn't need to be within non-strict metric range " do
    score = build(:score, value: 120)
    score.metric.update(strict: false)
    assert score.valid?
    score.value = -10
    assert score.valid?
    score.value = 10
    assert score.valid?
  end

  test "#effective_value for non strict metric" do
    score = build(:score, value: 120)
    score.metric.update(strict: false)
    assert_equal score.metric.best_score, score.effective_value
    score.value = -10
    assert_equal score.metric.worst_score, score.effective_value
    score.value = 10
    assert_equal 10, score.effective_value
  end
end
