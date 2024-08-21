require "test_helper"

module Evaluations
  class RunJobTest < ActiveJob::TestCase
    def setup
      @evaluation = Minitest::Mock.new
      @user = users("marek")
    end

    test "submits evaluations" do
      @evaluation.expect(:submit, true, [ @user ])
      RunJob.perform_now(evaluations: [ @evaluation ], user: @user)
      assert @evaluation.verify
    end
  end
end
