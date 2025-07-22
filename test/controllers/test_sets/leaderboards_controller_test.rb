require "test_helper"


module TestSets
  class LeaderboardsControllerTest < ActionDispatch::IntegrationTest
    def setup
      in_challenge!
    end

    test "should get index" do
      get test_set_leaderboard_path(test_set_id: test_sets("flores"))
      assert_response :success
    end

    test "doesn't show data when visibility is nil" do
      get test_set_leaderboard_path(test_set_id: test_sets("flores"))
      assert_includes response.body, "Leaderboards are not currently visible"
    end

    test "should filter index based on task id" do
      challenges(:global).update(visibility: "leaderboard_released")
      model = create(:model, name: "model", tasks: [ tasks(:st) ])
      hypothesis = create(:hypothesis, model:)
      evaluation = create(:evaluation, hypothesis:,
      evaluator: evaluators(:blueurt))
      score = create(:score, evaluation:, metric: metrics(:blueurt), value: 99.99)

      other = create(:model, name: "other task", tasks: [ tasks(:asr) ])
      other_hypothesis = create(:hypothesis, model: other, test_set_entry: test_set_entries(:flores_asr_en_pl))
      other_evaluation = create(:evaluation, hypothesis: other_hypothesis,
      evaluator: evaluators(:blueurt))
      other_score = create(:score, evaluation: other_evaluation, metric: metrics(:blueurt), value: 11.11)

      get test_set_leaderboard_path(test_set_id: test_sets("flores"), tid: tasks("st"))
      assert_response :success
      assert_includes response.body, score.value.to_s
      assert_not_includes response.body, other_score.value.to_s
    end
  end
end
