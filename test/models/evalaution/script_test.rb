require "test_helper"

class Evaluation::ScriptTest < ActiveSupport::TestCase
  test "task slug is passed as an ENV variable" do
    evaluation = create(:evaluation)
    script = Evaluation::Script.new(evaluation, "token")

    assert_includes script.to_h.dig(:job, :environment), "TASK=#{evaluation.hypothesis.test_set_entry.task.slug}"
  end
end
