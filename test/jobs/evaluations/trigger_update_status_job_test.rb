require "test_helper"

module Evaluations
  class TriggerUpdateStatusJobTest < ActiveJob::TestCase
    def setup
      Evaluator.stubs(:pluck).returns([ "ares", "atena" ])
    end

    test "does not enqueue jobs with no submitted evaluations" do
      create(:evaluation, status: :created, creator: users("marek"))
      assert_no_enqueued_jobs only: Evaluations::UpdateStatusJob do
        Evaluations::TriggerUpdateStatusJob.perform_now
      end
    end

    test "queues a job for every user and host" do
      hypothesis1 = build(:hypothesis)
      hypothesis2 = build(:hypothesis)
      create(:evaluation, status: :pending, hypothesis: hypothesis1, creator: users("marek"))
      create(:evaluation, status: :pending, hypothesis: hypothesis2, creator: users("marek"))

      assert_enqueued_jobs 2, only: Evaluations::UpdateStatusJob do
        Evaluations::TriggerUpdateStatusJob.perform_now
      end
    end
  end
end
