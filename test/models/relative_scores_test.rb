require "test_helper"

class RelativeScoresTest < ActiveSupport::TestCase
  def setup
    @test_set = test_sets(:flores)
    @metric = metrics(:blue)
    @test_set_entries = [ test_set_entries(:flores_st_en_pl), test_set_entries(:flores_st_en_de) ]
    hypothesis1 = create(:hypothesis, test_set_entry: @test_set_entries.first)
    hypothesis2 = create(:hypothesis, test_set_entry: @test_set_entries.first)
    hypothesis3 = create(:hypothesis, test_set_entry: @test_set_entries.second)
    hypothesis4 = create(:hypothesis, test_set_entry: @test_set_entries.second)
    evaluation1 = create(:evaluation, hypothesis: hypothesis1)
    evaluation2 = create(:evaluation, hypothesis: hypothesis2)
    evaluation3 = create(:evaluation, hypothesis: hypothesis3)
    evaluation4 = create(:evaluation, hypothesis: hypothesis4)
    create(:score, metric: @metric, evaluation: evaluation1, value: 10)
    create(:score, metric: @metric, evaluation: evaluation2, value: 50)
    create(:score, metric: @metric, evaluation: evaluation3, value: 20)
    create(:score, metric: @metric, evaluation: evaluation4, value: 80)
    @rows = Top::Row.where(task: tasks(:st), test_set: @test_set)
    @relative_scores = RelativeScores.new(@rows, [ @test_set ], [ @metric ], @test_set_entries)
  end

  test "best score without entry" do
    assert_equal 20, @relative_scores.best_score_for(@metric, @test_set) # 80 / 4 entries = 20
  end

  test "worst score without entry" do
    assert_equal 2.5, @relative_scores.worst_score_for(@metric, @test_set) # 10 / 4 entries = 2.5
  end

  test "best score with entry" do
    assert_equal 50, @relative_scores.best_score_for(@metric, @test_set, @test_set_entries.first)
    assert_equal 80, @relative_scores.best_score_for(@metric, @test_set, @test_set_entries.second)
  end

  test "worst score with entry" do
    assert_equal 10, @relative_scores.worst_score_for(@metric, @test_set, @test_set_entries.first)
    assert_equal 20, @relative_scores.worst_score_for(@metric, @test_set, @test_set_entries.second)
  end
end
