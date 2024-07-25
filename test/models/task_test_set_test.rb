require "test_helper"

class TaskTestSetTest < ActiveSupport::TestCase
  test "is unable to create a duplicate task test set" do
    task_test_set = TaskTestSet.new(
      task: TaskTestSet.first.task,
      test_set: TaskTestSet.first.test_set
    )
    assert_equal task_test_set.valid?, false
  end
end
