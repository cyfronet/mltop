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
    assert_difference("Hypothesis.count") do
      post submission_hypotheses_path(submission_id: @model.id, format: :turbo_stream),
        params: { hypothesis: { test_set_entry_id: @test_set_entry.id, model_id: @model.id, input: fixture_file_upload("input.txt") } }
    end

    assert_response :ok
    assert_equal "Hypothesis succesfully created", flash[:notice]
  end

  test "it returns uprocessable for invalid params" do
    @hypothesis = create(:hypothesis, model: @model, test_set_entry: @test_set_entry)

    assert_no_difference("Hypothesis.count") do
      post submission_hypotheses_path(submission_id: @model.id, format: :turbo_stream),
        params: { hypothesis: { test_set_entry_id: @test_set_entry.id, model_id: @model.id, input: fixture_file_upload("input.txt") } }
    end

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
