require "test_helper"

class Admin::Tasks::TestSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("marek")
    @task = tasks("st")
  end
  test "should get new" do
    get new_admin_task_test_set_path(@task)
    assert_response :success
  end

  test "should create task test set" do
    test_set = create(:test_set)

    assert_difference("TaskTestSet.count") do
      post admin_task_test_sets_path(@task, format: :turbo_stream),
        params: { task_test_set: { test_set_id: test_set.id } }
    end

    assert_response :ok
  end

  test "it returns uprocessable for missing params" do
    assert_no_difference("TaskTestSet.count") do
      post admin_task_test_sets_path(@task),
        params: { task_test_set: { test_set_id: nil } }
    end

    assert_response :unprocessable_entity
  end
end
