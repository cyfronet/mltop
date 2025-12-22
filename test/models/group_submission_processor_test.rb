require "test_helper"

class GroupSubmissionProcessorTest < ActiveSupport::TestCase
  setup do
    @user = users(:marek)
    Current.user = @user
    @model = create(:model, owner: @user, tasks: [ tasks(:st), tasks(:asr) ])
    @group_submission = GroupSubmission.new(name: "test", challenge: challenges(:global), user: @user, model: @model)
    @group_submission.file.attach(
      io: File.open(Rails.root.join("test/fixtures/files/group_submission.zip")),
      filename: "group_submission.zip"
    )
    @group_submission.save
  end
  test "should create hypotheses for valid zip structure" do
    assert_difference "@model.reload.hypotheses.count", 4 do
      GroupSubmissionProcessor.new(@group_submission).process
    end
    @group_submission.reload
    assert_equal "success", @group_submission.state
    assert_nil @group_submission.error_message
  end

  test "should not create hypotheses for invalid task" do
    @group_submission.file.attach(
      io: File.open(Rails.root.join("test/fixtures/files/group_submission_invalid_task.zip")),
      filename: "invalid_group_submission.zip"
    )
    assert_no_difference "Hypothesis.count" do
      GroupSubmissionProcessor.new(@group_submission).process
    end
    @group_submission.reload
    assert_equal "failed", @group_submission.state
    assert_equal "Invalid tasks invalid task", @group_submission.error_message
  end

  test "should not create hypotheses for invalid zip structure" do
    @group_submission.file.attach(
      io: File.open(Rails.root.join("test/fixtures/files/group_submission_invalid_structure.zip")),
      filename: "invalid_group_submission.zip"
    )
    assert_no_difference "Hypothesis.count" do
      GroupSubmissionProcessor.new(@group_submission).process
    end
    @group_submission.reload
    assert_equal "failed", @group_submission.state
    assert_equal "Submitted file is empty or has invalid structure", @group_submission.error_message
  end
end
