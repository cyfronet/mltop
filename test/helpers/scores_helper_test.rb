require "test_helper"

class ScoresHelperTest < ActionView::TestCase
  Normalized = Struct.new(:normalized) do
    def value = normalized
  end

  test "best score without entry" do
    assert_equal "rgb(4, 120, 87)", score_color(Normalized.new(1))
  end

  test "worst score without entry" do
    assert_equal "rgb(220, 38, 38)", score_color(Normalized.new(0))
  end
end
