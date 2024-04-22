require "test_helper"

class ModelTest < ActiveSupport::TestCase
  setup do
    @t2t = model_types("t2t")
  end

  test "sorting by metric" do
    m1 = create_model(name: "m1", blue: 1)
    m2 = create_model(name: "m2", blue: 3)
    m3 = create_model(name: "m3", blue: 2)

    asc = Model.ordered_by_metric(model_benchmarks_metrics(:blue), order: :asc)
    assert_equal m1, asc[0]
    assert_equal m3, asc[1]
    assert_equal m2, asc[2]

    desc = Model.ordered_by_metric(model_benchmarks_metrics(:blue))
    assert_equal m2, desc[0]
    assert_equal m3, desc[1]
    assert_equal m1, desc[2]
  end

  def create_model(name:, blue:, chrf: 0, ter: 0)
    model = @t2t.models.create(name:)

    model.scores.create(metric: model_benchmarks_metrics(:blue), value: blue)
    model.scores.create(metric: model_benchmarks_metrics(:chrf), value: chrf)
    model.scores.create(metric: model_benchmarks_metrics(:ter), value: ter)

    model
  end
end
