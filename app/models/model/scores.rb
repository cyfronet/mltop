class Model::Scores
  attr_reader :source_languages, :target_languages

  def initialize(model:, task:, metric:, test_set:)
    @test_set = test_set
    @scores_map = Score
      .joins(evaluation: { hypothesis: { groundtruth: [ :test_set_entry ] } })
      .where(evaluation: { hypotheses: { groundtruths: { test_set_entries: { test_set_id: test_set } }, model_id: model } }, metric_id: metric)
      .select("value, test_set_entries.language as source_language, groundtruths.language as target_language")
      .map { |score| [ [ score.source_language, score.target_language ], score.value ] }.to_h

    @target_languages = Groundtruth.where(task: task, test_set_entry: test_set.entries).pluck(:language).uniq.sort
    @source_languages = test_set.entries.pluck(:language).uniq.sort
  end

  def score(source_language, target_language)
    @scores_map[[ source_language, target_language ]]
  end
end
