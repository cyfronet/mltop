require "test_helper"

class DashboardTest < ActionDispatch::IntegrationTest
  test "only admin can enter adminland" do
    sign_in_as("marek")
    in_challenge!

    get edit_dashboard_challenge_path(challenges(:global))
    assert_response :success
    assert_match "Dashboard", response.body
  end

  test "normal user is redirected to root page" do
    sign_in_as("szymon", teams: [])
    in_challenge!

    get edit_dashboard_challenge_path(challenges(:global))
    assert_redirected_to root_path

    follow_redirect!
    assert_no_match "Dashboard", response.body
  end
end
