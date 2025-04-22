require "test_helper"

class TestSetsControllerTest < ActionDispatch::IntegrationTest
  def setup
    in_challenge!
  end

  test "should get index" do
    get test_sets_path
    assert_response :success
  end

  test "should get show" do
    get test_set_path(test_sets(:flores))
    assert_response :success
  end
end
