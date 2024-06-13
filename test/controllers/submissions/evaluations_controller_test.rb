require "test_helper"

class Submissions::EvaluationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    sign_in_as("marek")

    get submission_evaluations_path(create(:model, owner: users("marek")))
    assert_response :success
  end
end
