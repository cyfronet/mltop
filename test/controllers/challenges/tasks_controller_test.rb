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
  end
end
