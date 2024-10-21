require "test_helper"

class EvaluationTest < ActiveSupport::TestCase
  def setup
    hypothesis = create(:hypothesis)
    @evaluation = create(:evaluation, evaluator: evaluators(:sacrebleu), hypothesis:)
    @user = hypothesis.model.owner
  end

  test "can record all scores" do
    assert_changes -> { Score.count }, to: +3 do
      @evaluation.record_scores! valid_scores
    end
  end

  test "change status to completed when scores are recorded" do
    assert_changes -> { @evaluation.status }, to: "completed" do
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


  test "successful submit changes status to running" do
    Hpc::ClientMock.stub_submit

    assert_changes "@evaluation.status", from: "created", to: "pending" do
      @evaluation.submit(@user)
    end
  end

  test "unsuccessful submit changes status to error" do
    Hpc::ClientMock.stub_submit(code: 500)

    assert_changes "@evaluation.status", from: "created", to: "failed" do
      @evaluation.submit(@user)
    end
  end

  private
    def valid_scores   = { blue: 1, chrf: 2, ter: 3.3 }.with_indifferent_access
    def invalid_scores = { blue: 1, chrf: 2 }.with_indifferent_access
end
