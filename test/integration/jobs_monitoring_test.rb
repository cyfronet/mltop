# frozen_string_literal: true

require "test_helper"

class JobsMonitoringTest < ActionDispatch::IntegrationTest
  test "admin sees jobs monitoring UI" do
    ActiveJob::QueueAdapters::TestAdapter.any_instance.stubs(:queues).returns([])
    ActiveJob::QueueAdapters::TestAdapter.any_instance.stubs(:jobs_count).returns(0)
    ActiveJob::QueueAdapters::TestAdapter.any_instance.stubs(:activating).returns(true)

    sign_in_as "marek"
    get mission_control_jobs_path

    assert_response :ok
  end

  test "normal user cannot see jobs monitoring UI" do
    sign_in_as "szymon"

    get mission_control_jobs_path
    assert_response :redirect
  end
end
