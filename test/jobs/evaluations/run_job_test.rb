require "test_helper"

module Evaluations
  class RunJobTest < ActiveJob::TestCase
    def setup
      @evaluation = create(:evaluation)
      @user = users("marek")
    end

    test "submits evaluations" do
      stub_ssh_connection
      Evaluation.any_instance.expects(:run).returns(true)
      RunJob.perform_now(evaluations: [ @evaluation ], user: @user)
    end

    private

      def stub_ssh_connection
        HPCKit::Slurm::Backends::Netssh.stubs(:new)
        @restd = Minitest::Mock.new
        @restd_runner = Minitest::Mock.new
        HPCKit::Slurm::Restd.stubs(:new).returns(@restd)
        @restd.expect(:start, nil) do |&block|
          block.call(@restd_runner)
        end
      end
  end
end
