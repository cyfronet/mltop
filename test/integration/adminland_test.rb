require "test_helper"

class AdminlandTest < ActionDispatch::IntegrationTest
  test "only admin can enter adminland" do
    sign_in_as("marek")

    get admin_tasks_path
    assert_response :success
    assert_match "Adminland", response.body
  end

  test "normal user is redirected to root page" do
    sign_in_as("szymon")

    get admin_tasks_path
    assert_redirected_to root_path

    follow_redirect!
    assert_no_match "Adminland", response.body
  end
end
