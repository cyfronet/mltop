class Top::ModelRow
  def initialize(model:, metric:, test_set:)
    @model = model
    @metric = metric
    @test_set = test_set

    @scores_map = Score.select("value, subtasks.source_language, subtasks.target_language")
      .joins(evaluation: { subtask_test_set: :subtask })
      .where(metric_id: metric, evaluations: { subtask_test_sets: { test_set_id: test_set } })
      .map { |s| [ [ s.source_language, s.target_language ], s.value ] }.to_h
  end

  delegate :source_languages, :target_languages, to: :@test_set

  def score(source_language, target_language)
    @scores_map[[ source_language, target_language ]]
  end
end
