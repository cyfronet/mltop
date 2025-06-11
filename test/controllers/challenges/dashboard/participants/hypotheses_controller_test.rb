require "test_helper"

class Challenges::Dashboard::Participants::HypothesesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("marek")
    in_challenge!
  end

  test "should get index" do
    get dashboard_participant_hypotheses_path(users(:marek))
    assert_response :success
  end
end
