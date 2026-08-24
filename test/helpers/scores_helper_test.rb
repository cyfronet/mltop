require "test_helper"

class ScoresHelperTest < ActionView::TestCase
  Normalized = Struct.new(:normalized) do
    def value = normalized
  end

  test "best score without entry" do
    assert_equal "rgba(188,11,175, 1)", score_color(Normalized.new(1))
  end

  test "worst score without entry" do
    assert_equal "rgba(188,11,175, 0)", score_color(Normalized.new(0))
  end
end
