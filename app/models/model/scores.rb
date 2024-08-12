class Model::Scores
  delegate :source_languages, :target_languages, to: :@test_set

  def initialize(model:, task:, metric:, test_set:)
    @test_set = test_set
    @scores_map = Score
      .joins(evaluation: { hypothesis: :test_set_entry })
      .where(evaluation: { hypotheses: { test_set_entries: { test_set_id: test_set }, model_id: model } }, metric_id: metric)
      .select("value, test_set_entries.source_language as source_language, test_set_entries.target_language as target_language")
      .map { |score| [ [ score.source_language, score.target_language ], score.value ] }.to_h
  end

  def score(source_language, target_language)
    @scores_map[[ source_language, target_language ]]
  end
end
