require "test_helper"

class EvaluationTest < ActiveSupport::TestCase
  def setup
    @evaluation = create(:evaluation, evaluator: evaluators(:sacrebleu))
  end

  test "can record all scores" do
    assert_changes -> { Score.count }, +3 do
      @evaluation.record_scores! valid_scores
    end
  end

  test "cannot record with missing scores" do
    assert_no_changes -> { Score.count }  do
      assert_raise ActiveRecord::RecordInvalid do
        @evaluation.record_scores! invalid_scores
      end
    end
  end

  test "cannot create duplicated scores" do
    @evaluation.record_scores! valid_scores


    assert_no_changes -> { Score.count }  do
      assert_raise ActiveRecord::RecordInvalid do
        @evaluation.record_scores! valid_scores
      end
    end
  end

  private
    def valid_scores   = { blue: 1, chrf: 2, ter: 3.3 }.with_indifferent_access
    def invalid_scores = { blue: 1, chrf: 2 }.with_indifferent_access
end
