require "test_helper"

module Challenges
  module Submissions
    class TasksControllerTest < ActionDispatch::IntegrationTest
      def setup
        in_challenge!
        sign_in_as("marek")
        @model = create(:model, owner: users("marek"))
      end

      test "redirects to first submissions task" do
        get submission_tasks_path(@model)
        assert_redirected_to submission_task_path(@model, @model.tasks.first)
      end

      test "should get index" do
        get submission_task_path(@model, @model.tasks.first)
        assert_response :success
      end
    end
  end
end
