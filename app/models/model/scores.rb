class Model::Scores
  attr_reader :model, :task, :metric, :test_set

  def initialize(model:, task:, metric:, test_set:)
    @test_set = test_set
    @task = task
    @model = model
    @metric = metric
    @scores_map = Score
      .joins(evaluation: { hypothesis: { test_set_entry: :task_test_set } })
      .where(evaluation: { hypotheses: { test_set_entries: { task_test_sets: { test_set_id: test_set, task:  } }, model_id: model } }, metric_id: metric)
      .select("value, test_set_entries.source_language as source_language, test_set_entries.target_language as target_language")
      .map { |score| [ [ score.source_language, score.target_language ], score.value ] }.to_h
  end

  def present?
    @task && @test_set && @metric
  end

  def score(source_language, target_language)
    value = @scores_map[[ source_language, target_language ]]

    if value
      normalized = Top::Normalizer.normalize(value, @metric.best_score, @metric.worst_score, @metric.asc?)
      Top::ScoreWithNormalization.new(score: Score.new(value:), normalized: normalized)
    end
  end

  def source_languages
    @test_set.source_languages_for(task: @task)
  end

  def target_languages
    @test_set.target_languages_for(task: @task)
  end
end
