require "test_helper"

module Evaluations
  class TriggerUpdateStatusJobTest < ActiveJob::TestCase
    def setup
      Evaluator.stubs(:pluck).returns([ "ares", "atena" ])
    end

    test "does not enqueue jobs with no submitted evaluations" do
      create(:evaluation, status: :created)
      assert_no_enqueued_jobs only: Evaluations::UpdateStatusJob do
        Evaluations::TriggerUpdateStatusJob.perform_now
      end
    end

    test "queues a job for every user and host" do
      model1 = build(:model, owner: users("marek"))
      model2 = build(:model, owner: users("marek"))

      hypothesis1 = build(:hypothesis, model: model1)
      hypothesis2 = build(:hypothesis, model: model2)
      create(:evaluation, status: :pending, hypothesis: hypothesis1)
      create(:evaluation, status: :pending, hypothesis: hypothesis2)

      assert_enqueued_jobs 2, only: Evaluations::UpdateStatusJob do
        Evaluations::TriggerUpdateStatusJob.perform_now
      end
    end
  end
end
