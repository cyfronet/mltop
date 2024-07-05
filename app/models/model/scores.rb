class Model::Scores
  attr_reader :source_languages, :target_languages

  def initialize(model:, task:, metric:, test_set:)
    @test_set = test_set
    @scores_map = Score
      .joins(evaluation: { hypothesis: { groundtruth: [ :subtask, :test_set_entry ] } })
      .where(evaluation: { hypotheses: { groundtruths: { test_set_entries: { test_set_id: test_set } }, model_id: model } }, metric_id: metric)
      .select("value, subtasks.source_language, subtasks.target_language")
      .map { |s| [ [ s.source_language, s.target_language ], s.value ] }.to_h

    languages = Subtask.where(task_id: task).pluck(:source_language, :target_language)
    @source_languages = languages.map(&:first).uniq.sort
    @target_languages = languages.map(&:last).uniq.sort
  end

  def score(source_language, target_language)
    @scores_map[[ source_language, target_language ]]
  end
end
