require "test_helper"

class SessionsTest < ActionDispatch::IntegrationTest
  test "user can log in" do
    sign_in_as("marek")
    get root_path

    assert_response :success
    assert_match "My submissions", response.body
  end

  test "user can log out" do
    sign_in_as("marek")
    delete sign_out_path

    assert_redirected_to root_path

    follow_redirect!
    assert_no_match "My submissions", response.body
  end
end
