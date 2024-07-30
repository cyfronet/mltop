require "test_helper"


class Admin::TestSetEntriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("marek")
  end
  test "should get new" do
    test_set = create(:test_set)
    get new_admin_test_set_test_set_entry_path(test_set)
    assert_response :success
  end
  test "should get index" do
    test_set = create(:test_set)
    get admin_test_set_path(test_set)
    assert_response :success
  end
  test "should create test set entry" do
    test_set = create(:test_set)
    dummy_input = Rack::Test::UploadedFile.new(StringIO.new("input"), "text/plain", original_filename: "input.txt")
    assert_difference("TestSet.last.entries.count") do
      post admin_test_set_test_set_entries_path(test_set), params: { test_set_entry: { language: "pl", input: dummy_input } }
    end
    assert_redirected_to admin_test_set_path(test_set)
  end
  test "should destroy test set entry" do
    test_set = create(:test_set)
    test_set_entry = create(:test_set_entry)
    assert_difference("TestSet.last.entries.count", -1) do
      delete admin_test_set_test_set_entry_path(test_set, test_set_entry)
    end
    assert_redirected_to admin_test_set_path(test_set)
  end
end
