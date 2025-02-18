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

  test "nillify token after scores are recorded" do
    @evaluation.update(token: "secret")
    @evaluation.record_scores! valid_scores

    assert_nil @evaluation.reload.token
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

  test "#active? when evaluation is running" do
    %i[ pending running ].each do |status|
      @evaluation.status = status
      assert @evaluation.active?, "Evaluation shoud be active for #{status} status"
    end

    %i[ created completed failed ].each do |status|
      @evaluation.status = status
      assert_not @evaluation.active?, "Evaluation shoudn't be active for #{status} status"
    end
  end


  test "successful started evaluation changes status to running" do
    Hpc::ClientMock.stub_submit

    assert_changes "@evaluation.status", from: "created", to: "pending" do
      @evaluation.run(@user)
    end
  end

  test "unsuccessful started evaluation changes status to error" do
    Hpc::ClientMock.stub_submit(code: 500)

    assert_changes "@evaluation.status", from: "created", to: "failed" do
      @evaluation.run(@user)
    end
  end

  test "nillify token after status updated to completed or failed" do
    %w[ completed failed ].each do |status|
      @evaluation.update status: :created, token: "secret"
      @evaluation.update job_status: status

      assert_nil @evaluation.token
    end

    @evaluation.update status: :created, token: "secret"
    %w[ pending running ].each do |status|
      @evaluation.update job_status: status

      assert_not_nil @evaluation.token
    end
  end

  test "evaluation failed when finished and no scores" do
    @evaluation.update job_status: "COMPLETED"

    assert @evaluation.failed?,
      "Evaluation should fail when finished and no results but it is #{@evaluation.status}"
  end

  private
    def valid_scores   = { blue: 1, chrf: 2, ter: 3.3 }.with_indifferent_access
    def invalid_scores = { blue: 1, chrf: 2 }.with_indifferent_access
end
