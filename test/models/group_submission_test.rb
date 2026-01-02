require "test_helper"

class GroupSubmissionTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
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
  test "enqueues processing job" do
    assert_enqueued_jobs 1, only: ::GroupSubmissions::ProcessJob do
      @group_submission.process_later
    end
  end
end
