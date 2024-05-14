class Top::ModelRow
  def initialize(model, metric, test_set)
    @model = model
    @metric = metric
    @test_set = test_set
  end

  def all_source_languages
    @test_set.subtasks.map(&:source_language).uniq.sort
  end

  def all_target_languages
    @test_set.subtasks.map(&:target_language).uniq.sort
  end

  def get_subtask_specific_score(source_language, target_language)
    subtask = Subtask.find_by(source_language: source_language, target_language: target_language)
    evaluator = @metric.evaluator
    subtask_test_set = SubtaskTestSet.find_by(subtask: subtask, test_set: @test_set)
    evaluation = Evaluation.find_by(subtask_test_set: subtask_test_set, model: @model, evaluator: evaluator)
    score = Score.find_by(evaluation: evaluation, metric: @metric)
    return nil unless score
    score.value
  end
end
