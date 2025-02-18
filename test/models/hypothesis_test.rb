require "test_helper"

class HypothesisTest < ActiveSupport::TestCase
  test "cannot create hypothesis without input" do
    model = create(:model)
    test_set_entry = test_set_entries("flores_st_en_pl")

    assert_not Hypothesis.new(model:, test_set_entry:).valid?
    assert Hypothesis.new(model:, test_set_entry:, input: upload_file).valid?
  end

  test "cannot create two hypothesis with same test_set_entry and model" do
    model = create(:model)
    test_set_entry = test_set_entries("flores_st_en_pl")

    Hypothesis.create(model:, test_set_entry:, input: upload_file)
    assert_not Hypothesis.new(model:, test_set_entry:, input: upload_file).valid?
  end

  test "cannot start evaluations twice" do
    model = create(:model)
    test_set_entry = test_set_entries("flores_st_en_pl")
    hypothesis = create(:hypothesis, model:, test_set_entry:)

    assert_changes "Evaluation.count", to: +2 do
      hypothesis.evaluate_missing!
    end

    assert_no_changes "Evaluation.count" do
      hypothesis.evaluate_missing!
    end
  end

  test "start only missing evaluations" do
    model = create(:model)
    test_set_entry = test_set_entries("flores_st_en_pl")
    hypothesis = create(:hypothesis, model:, test_set_entry:)

    create(:evaluation, hypothesis:, evaluator: test_set_entry.task.evaluators.first)

    assert_difference "Evaluation.count", +1 do
      hypothesis.evaluate_missing!
    end

    assert_equal evaluators.map(&:name).sort,
      hypothesis.evaluations.map { it.evaluator.name }.sort
  end

  test "no evaluation is created when any error occur" do
    model = create(:model)
    test_set_entry = test_set_entries("flores_st_en_pl")
    hypothesis = create(:hypothesis, model:, test_set_entry:)
    create(:evaluation, hypothesis:, evaluator: test_set_entry.task.evaluators.first)
    create(:evaluation, hypothesis:, evaluator: test_set_entry.task.evaluators.second)

    assert_no_changes "Evaluation.count" do
      hypothesis.evaluate_missing!
    end
  end

  test "#fully_evaluated?" do
    model = create(:model)
    test_set_entry = test_set_entries("flores_st_en_pl")
    hypothesis = create(:hypothesis, model:, test_set_entry:)

    assert_not hypothesis.fully_evaluated?

    create(:evaluation, hypothesis:, evaluator: test_set_entry.task.evaluators.first)
    assert_not hypothesis.reload.fully_evaluated?

    create(:evaluation, hypothesis:, evaluator: test_set_entry.task.evaluators.second)
    assert hypothesis.reload.fully_evaluated?
  end

  private
    def upload_file
      { io: StringIO.new("input"), filename: "input.txt" }
    end
end
