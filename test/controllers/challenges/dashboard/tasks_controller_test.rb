require "test_helper"

class Challenges::Dashboard::TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    challenge_member_signs_in("marek", challenges(:global), teams: [ "plggmeetween" ])
  end

  test "should get index" do
    get dashboard_tasks_path
    assert_response :success
  end

  test "should get new" do
    get new_dashboard_task_path
    assert_response :success
  end

  test "should create task" do
    Current.challenge = challenges(:global)
    task = build(:task)

    assert_difference("Task.count") do
      post dashboard_tasks_url, params: { task: {
        name: task.name,  slug: task.slug, from: task.from, to: task.to
      } }
    end

    assert_redirected_to dashboard_task_path(Task.last)
  end

  test "should show user" do
    task = create(:task)

    get dashboard_task_path(task)
    assert_response :success
  end

  test "should get edit" do
    task = create(:task)

    get edit_dashboard_task_path(task)
    assert_response :success
  end

  test "should update user" do
    task = create(:task)

    patch dashboard_task_path(task), params: { task: { name: "update name" } }
    assert_redirected_to dashboard_task_path(task)
  end

  test "should destroy user" do
    task = create(:task)

    assert_difference("Task.count", -1) do
      delete dashboard_task_path(task)
    end

    assert_redirected_to dashboard_tasks_path
  end
end
