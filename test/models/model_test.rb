require "test_helper"

class ModelTest < ActiveSupport::TestCase
  test "model needs to belong to at least one task" do
    model = build(:model, tasks: [])

    assert_not model.valid?
  end

  test "find all external models" do
    external = create(:model, owner: users("external"))
    create(:model, owner: users("marek"))

    assert_equal [ external ], Model.external
  end

  test "find models with not evaluated hypothesis" do
    _empty_model = create(:model)

    with_all_hypothesis_evaluated = create(:model)
    evaluated_hypothesis = create(:hypothesis, model: with_all_hypothesis_evaluated)
    create(:evaluation, hypothesis: evaluated_hypothesis)

    with_evaluation_pending = create(:model)
    not_validated_hypothesis = create(:hypothesis, model: with_evaluation_pending)
    evaluated_hypothesis = create(:hypothesis,
      model: with_evaluation_pending,
      test_set_entry: test_set_entries("flores_st_en_it"))
    create(:evaluation, hypothesis: evaluated_hypothesis)

    not_evaluated = Model.with_not_evaluated_hypotheses

    assert_equal [ with_evaluation_pending ], not_evaluated
    assert_equal [ not_validated_hypothesis ], not_evaluated.first.hypotheses,
      "Only not evaluated hypothesis should be loaded"
  end
end
