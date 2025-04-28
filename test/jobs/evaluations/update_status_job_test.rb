require "test_helper"

module Evaluations
  class UpdateStatusJobTest < ActiveJob::TestCase
    def setup
      Evaluator.stubs(:pluck).returns([ "ares", "atena" ])
    end

    test "returns error for timeout" do
      evaluation1 = create(:evaluation, job_id: "1", status: :pending, creator: users("marek"))

      Hpc::ClientMock.stub_jobs([ "1", "2" ], code: 422, body: "Timeout")

      Rails.logger.expects(:warn)
      assert_no_changes "evaluation1.status" do
        UpdateStatusJob.perform_now(users("marek"), evaluation1.evaluator.host)
      end
    end

    test "updates evaluations status for successull call" do
      evaluation1 = create(:evaluation, job_id: "1", status: :pending, creator: users("marek"))
      evaluation2 = create(:evaluation, job_id: "2", status: :pending, creator: users("marek"))
      Hpc::ClientMock.stub_jobs([ "1", "2" ])

      UpdateStatusJob.perform_now(users("marek"), evaluation1.evaluator.host)

      assert_equal evaluation1.reload.status, "running"
      assert_equal evaluation2.reload.status, "running"
    end

    test "does not update the status if it's the same" do
      Hpc::ClientMock.stub_jobs([ "1", "2" ])
      evaluation1 = create(:evaluation, job_id: "1", status: :running, creator: users("marek"))

      assert_no_changes "evaluation1.status" do
        UpdateStatusJob.perform_now(users("marek"), evaluation1.evaluator.host)
      end
    end


    test "does not call hpc client when evaluations are not running" do
      evaluation1 = create(:evaluation, job_id: "1", status: :completed, creator: users("marek"))

      Hpc::Response.expects(:new).never

      assert_no_changes "evaluation1.status" do
        UpdateStatusJob.perform_now(users("marek"), evaluation1.evaluator.host)
      end
    end

    test "does nothing for nonsubmitted evaluations" do
      model1 = build(:model)
      model2 = build(:model)

      hypothesis1 = build(:hypothesis, model: model1)
      hypothesis2 = build(:hypothesis, model: model2)
      create(:evaluation, status: :pending, hypothesis: hypothesis1, creator: users("marek"))
      create(:evaluation, status: :pending, hypothesis: hypothesis2, creator: users("marek"))

      assert_enqueued_jobs 2, only: Evaluations::UpdateStatusJob do
        Evaluations::TriggerUpdateStatusJob.perform_now
      end
    end
  end
end
