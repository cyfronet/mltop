require "test_helper"

class Admin::Tasks::GroundtruthsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("marek")
    @task = tasks("st")
    @test_set_entry = test_set_entries("flores_en")
  end
  test "should get new" do
    get new_admin_task_groundtruth_path(@task)
    assert_response :success
  end

  test "should create groundtruth" do
    assert_difference("Groundtruth.count") do
      post admin_task_groundtruths_path(@task), params: { groundtruth: {
        test_set_entry_id: @test_set_entry.id,  input: fixture_file_upload("input.txt"), language: "en"
      } }
    end

    assert_redirected_to admin_task_path(@task)
  end

  test "it returns uprocessable for missing params" do
    assert_no_difference("Groundtruth.count") do
      post admin_task_groundtruths_path(@task), params: { groundtruth: {
        test_set_entry_id: @test_set_entry.id,  input: nil, language: "en"
      } }
    end

    assert_response :unprocessable_entity
  end
end
