require "test_helper"

class Admin::Participants::HypothesesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("marek")
  end

  test "should get index" do
    get admin_participant_hypotheses_path(users(:marek))
    assert_response :success
  end
end
