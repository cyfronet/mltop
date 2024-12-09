require "test_helper"

class ExternalSubmissionsControllerTest < ActionDispatch::IntegrationTest
  test "Meetween member can manage external users submissions" do
    sign_in_as("marek")

    get external_submissions_path
    assert_response :success
  end

  test "External user cannot manage external users submissions" do
    sign_in_as("external", teams: [ "plggother" ])

    get external_submissions_path
    assert_response :redirect

    follow_redirect!
    assert_includes response.body, "Only Meetween members can manage"
  end
end
