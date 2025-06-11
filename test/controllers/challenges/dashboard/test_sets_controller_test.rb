require "test_helper"

class Challenges::Dashboard::TestSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("marek")
    in_challenge!
  end

  test "should get index" do
    get dashboard_test_sets_path
    assert_response :success
  end
  test "should get specific test set index" do
    test_set = test_sets("flores")
    get dashboard_test_set_path(test_set)
    assert_response :success
  end

  test "should get new" do
    get new_dashboard_test_set_path
    assert_response :success
  end

  test "should create test set" do
    test_set = build(:test_set)
    assert_difference("TestSet.count") do
      post dashboard_test_sets_url, params: { test_set: { name: test_set.name } }
    end
    assert_redirected_to dashboard_test_set_path(TestSet.last)
  end

  test "should show test set" do
    test_set = create(:test_set)

    get dashboard_test_set_path(test_set)
    assert_response :success
  end

  test "should get edit" do
    test_set = create(:test_set)
    get edit_dashboard_test_set_path(test_set)
    assert_response :success
  end

  test "should update test set" do
    test_set = create(:test_set)
    patch dashboard_test_set_path(test_set), params: { test_set: { name: "updated name" } }
    assert_redirected_to dashboard_test_set_path(test_set)
  end

  test "should destroy test set" do
    test_set = create(:test_set)
    assert_difference("TestSet.count", -1) do
      delete dashboard_test_set_path(test_set)
    end
    assert_redirected_to dashboard_test_sets_path
  end
end
