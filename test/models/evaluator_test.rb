require "test_helper"

class EvaluatorTest < ActiveSupport::TestCase
  test "should allow manual evaluators without script or directory" do
    evaluator = Evaluator.new(
      challenge: challenges(:global),
      name: "Manual Evaluator",
      kind: "manual",
      script: "",
      directory: ""
    )
    assert evaluator.valid?
  end
end
