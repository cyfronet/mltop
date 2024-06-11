require "test_helper"

class Submissions::ResultsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get submissions_results_index_url
    assert_response :success
  end
end
