require "test_helper"

class Submissions::HypothesesControllerTest < ActionDispatch::IntegrationTest
  def setup
    in_challenge!
    sign_in_as("marek")
    @model = create(:model, owner: users("marek"))
    @task = @model.tasks.first
    @test_set_entry = test_set_entries("flores_st_en_it")
  end

  test "should create hypotheses" do
    file = fixture_file_upload("input.txt", "text/plain")
    blob = ActiveStorage::Blob.create_and_upload!(
      io: file,
      filename: "input.txt",
      content_type: "text/plain"
    )
    assert_difference("Hypothesis.count") do
      post submission_hypotheses_path(submission_id: @model.id),
        params: { hypothesis: { test_set_entry_id: @test_set_entry.id, model_id: @model.id, input: blob.signed_id } }
    end

    assert_response :redirect
    follow_redirect!
    assert_equal "Hypothesis succesfully created", flash[:notice]
  end

  test "it returns uprocessable for invalid params" do
    file = fixture_file_upload("input.txt", "text/plain")
    blob = ActiveStorage::Blob.create_and_upload!(
      io: file,
      filename: "input.txt",
      content_type: "text/plain"
    )
    @hypothesis = create(:hypothesis, model: @model, test_set_entry: @test_set_entry)

    assert_no_difference("Hypothesis.count") do
      post submission_hypotheses_path(submission_id: @model.id),
        params: { hypothesis: { test_set_entry_id: @test_set_entry.id, model_id: @model.id, input: blob.signed_id } }
    end

    assert_response :redirect
    follow_redirect!
    assert_equal "Unable to create hypothesis", flash[:alert]
  end

  test "should delete hypothesis" do
    @hypothesis = create(:hypothesis, model: @model, test_set_entry: @test_set_entry)
    assert_difference("Hypothesis.count", -1) do
      delete hypothesis_path(id: @hypothesis.id, format: :turbo_stream)
    end

    assert_response :ok
    assert_equal "Hypothesis succesfully deleted", flash[:notice]
  end
end
