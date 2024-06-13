require "test_helper"

class Submissions::ResultsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in_as("marek")

    get submission_results_path(create(:model, owner: users("marek")))
    assert_response :success
  end
end
