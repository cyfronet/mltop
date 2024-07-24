require "test_helper"

class Admin::TestSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("marek")
  end
  test "should get index" do
    get admin_test_sets_path
    assert_response :success
  end

  test "should get new" do
    get new_admin_test_sets_path
    assert_reponse :success
  end
  test "should create test set" do
    test_set = build(:test_set)
    assert_difference("TestSet.count") do
      post admin_test_sets_url, params: { test_set: { name: test_set.name } }
    end
    assert_redirected_to admin_test_set_path(TestSet.last)
    end
end
