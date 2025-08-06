require "test_helper"

class SessionsTest < ActionDispatch::IntegrationTest
  test "Challenge manager can log in through PLGrid and see external users submissions" do
    in_challenge!(users(:marek), :manager)
    sign_in_as("marek", teams: [ "plggmeetween", "plgother" ])
    get root_path

    assert_response :success
    assert_match "My submissions", response.body
    assert_match "External submissions", response.body
  end

  test "Non challenge managers can log in through PLGrid, but do not see external submissions" do
    sign_in_as("szymon", teams: [ "plggother" ])
    in_challenge!

    get root_path

    assert_match "My submissions", response.body
    assert_no_match "External submissions", response.body
  end

  test "Meetween members session is scoped to ssh certificate validation" do
    sign_in_as("marek", teams: [ "plggmeetween" ])
    in_challenge!

    get submissions_path
    assert_response :success

    users("marek").update(ssh_key: nil, ssh_certificate: nil)
    get submissions_path
    assert_response :redirect
    follow_redirect!
    assert_no_match "My submissions", response.body
  end

  test "User can log in through Github" do
    user = build(:user)
    github_sign_in_as(user)

    assert_response :redirect
    follow_redirect!
    assert_match challenges(:global).name, response.body

    in_challenge!
    get root_path
    assert_match "My submissions", response.body
  end

  test "user can log out" do
    sign_in_as("marek")
    delete sign_out_path

    assert_redirected_to root_path

    follow_redirect!
    assert_match "Log in", response.body

    in_challenge!
    get root_path
    assert_no_match "My submissions", response.body
  end
end
