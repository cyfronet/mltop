require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit tasks_url
    assert_text "Speech-to-text Translation (ST)"
  end
end
