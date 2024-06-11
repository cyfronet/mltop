require "test_helper"

class Submissions::EvaluationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get submissions_evaluations_index_url
    assert_response :success
  end
end
