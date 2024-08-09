require "test_helper"

class Submissions::HypothesesControllerTest < ActionDispatch::IntegrationTest
  def setup
    sign_in_as("marek")
    @model = create(:model, owner: users("marek"))
    @task = @model.tasks.first
    @groundtruth = groundtruths("flores_en_it_st")
  end

  test "should get new" do
    get submission_tasks_path(@model)
    assert_redirected_to submission_task_path(@model, @model.tasks.first)
  end

  test "should create hypotheses" do
    assert_difference("Hypothesis.count") do
      post submission_hypotheses_path(submission_id: @model.id, format: :turbo_stream),
        params: { hypothesis: { groundtruth_id: @groundtruth.id, model_id: @model.id, input: fixture_file_upload("input.txt") } }
    end

    assert_response :ok
    assert_equal "Hypothesis succesfully created", flash[:notice]
  end

  test "it returns uprocessable for invalid params" do
    @hypothesis = create(:hypothesis, model: @model, groundtruth: @groundtruth)

    assert_no_difference("Hypothesis.count") do
      post submission_hypotheses_path(submission_id: @model.id),
        params: { hypothesis: { groundtruth_id: @groundtruth.id, model_id: @model.id, input: fixture_file_upload("input.txt") } }
    end

    assert_response :unprocessable_entity
  end

  test "should delete hypothesis" do
    @hypothesis = create(:hypothesis, model: @model, groundtruth: @groundtruth)
    assert_difference("Hypothesis.count", -1) do
      delete submission_hypotheses_path(submission_id: @model.id, groundtruth_id: @groundtruth.id, format: :turbo_stream)
    end

    assert_response :ok
    assert_equal "Hypothesis succesfully deleted", flash[:notice]
  end
end
