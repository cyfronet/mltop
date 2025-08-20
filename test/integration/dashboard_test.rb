require "test_helper"

class DashboardTest < ActionDispatch::IntegrationTest
  test "only admin can enter adminland" do
    challenge_member_signs_in("marek", challenges(:global), teams: [ "plggmeetween" ])
    grant_admin_access_to(:marek, challenges(:global))

    get edit_dashboard_challenge_path(challenges(:global))
    assert_response :success
    assert_match "Update Challenge", response.body
  end

  test "Challenge participant is redirected to root page" do
    challenge_member_signs_in("szymon", challenges(:global), teams: [ "plgggemini" ])

    get edit_dashboard_challenge_path(challenges(:global))
    assert_redirected_to root_path

    follow_redirect!
    assert_no_match "Dashboard", response.body
  end

  test "User without membership is redirected to root page" do
    sign_in_as("szymon", teams: [ "plgggemini" ])
    in_challenge!

    get edit_dashboard_challenge_path(challenges(:global))
    assert_redirected_to root_path

    follow_redirect!
    assert_no_match "Dashboard", response.body
  end
end
