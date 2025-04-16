require "test_helper"

class Admin::TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("marek")
  end

  test "should get index" do
    get admin_tasks_path
    assert_response :success
  end

  test "should get new" do
    get new_admin_task_path
    assert_response :success
  end

  test "should create user" do
    task = build(:task)

    assert_difference("Task.count") do
      post admin_tasks_url, params: { task: {
        name: task.name,  slug: task.slug, from: task.from, to: task.to, challenge_id: challenges(:global).id
      } }
    end

    assert_redirected_to admin_task_path(Task.last)
  end

  test "should show user" do
    task = create(:task)

    get admin_task_path(task)
    assert_response :success
  end

  test "should get edit" do
    task = create(:task)

    get edit_admin_task_path(task)
    assert_response :success
  end

  test "should update user" do
    task = create(:task)

    patch admin_task_path(task), params: { task: { name: "update name" } }
    assert_redirected_to admin_task_path(task)
  end

  test "should destroy user" do
    task = create(:task)

    assert_difference("Task.count", -1) do
      delete admin_task_path(task)
    end

    assert_redirected_to admin_tasks_path
  end
end
