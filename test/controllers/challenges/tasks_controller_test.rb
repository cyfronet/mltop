require "test_helper"

module Challenges
  class TasksControllerTest < ActionDispatch::IntegrationTest
    def setup
      in_challenge!
    end

    test "should get index" do
      get tasks_url
      assert_response :success
    end

    test "should show task" do
      get task_url(tasks(:st))
      assert_response :success
    end

    test "index should show challenge paragraphs" do
      challenges(:global).update(introduction: "introduction", call_to_action: "call to action")
      get tasks_url
      assert_response :success
      assert_includes response.body, "introduction"
      assert_includes response.body, "call to action"
    end
  end
end
