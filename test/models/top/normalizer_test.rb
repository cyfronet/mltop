require "test_helper"

class Top::NormalizerTest < ActiveSupport::TestCase
  include EvaluationHelpers

  def setup
    m1, m2, m3 = create_list(:model, 3, tasks: [ tasks(:st) ])

    @metric = metrics(:blueurt)

    new_evaluation(m1, :flores_st_en_pl, 100, metric: @metric)
    new_evaluation(m2, :flores_st_en_pl, 50, metric: @metric)
    new_evaluation(m3, :flores_st_en_pl, 75, metric: @metric)

    @rows = Top::Row.where(task: tasks(:st))
    @normalizer = Top::Normalizer.new(@rows)
  end

  test "by default use absolute normalization" do
    assert_equal 1, normalize(100)
    assert_equal 0.5, normalize(50)
    assert_equal 0, normalize(0)
  end

  test "relative normalization" do
    @normalizer.relative!

    assert_equal 1, normalize(100)
    assert_equal 0.5, normalize(75)
    assert_equal 0, normalize(50)
  end

  test "absolute normalization with ascending metric" do
    @metric.update!(best_score: 0, worst_score: 100)

    assert_equal 1, normalize(0)
    assert_equal 0.5, normalize(50)
    assert_equal 0, normalize(100)
  end

  test "relative normalization with ascending metric" do
    @metric.update!(best_score: 0, worst_score: 100)
    @normalizer.relative!

    assert_equal 1, normalize(50)
    assert_equal 0.5, normalize(75)
    assert_equal 0, normalize(100)
  end

  test "returns 1 when all scores are the same" do
    @metric.scores.update_all(value: 50)
    @rows = Top::Row.where(task: tasks(:st))
    @normalizer = Top::Normalizer.new(@rows)
    @normalizer.relative!
    assert_equal 1, normalize(50)
  end

  test "returns nil fro nil value" do
    assert_nil normalize(nil)
  end

  private
    def normalize(value)
      @normalizer.normalize(value, test_sets(:flores), @metric, test_set_entries(:flores_st_en_pl))
    end
end
