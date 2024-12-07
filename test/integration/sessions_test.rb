require "test_helper"

class SessionsTest < ActionDispatch::IntegrationTest
  test "meetween user can log in" do
    sign_in_as("marek", teams: [ "plggmeetween", "plgother" ])
    get root_path

    assert_response :success
    assert_match "My submissions", response.body
  end

  test "other plgrid users cannot login" do
    sign_in_as("marek", teams: [ "plggother" ])

    assert_response :redirect
    follow_redirect!

    assert_match "Only Meetween project members can login right now", response.body
    assert_no_match "My submissions", response.body
  end

  test "user can log out" do
    sign_in_as("marek")
    delete sign_out_path

    assert_redirected_to root_path

    follow_redirect!
    assert_no_match "My submissions", response.body
  end
end
