require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get tasks_url
    assert_response :success
  end

  test "should show task" do
    get task_url(tasks(:st))
    assert_response :success
  end
end
