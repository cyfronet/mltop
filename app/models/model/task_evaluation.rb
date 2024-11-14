class Model::TaskEvaluation
  def initialize(model:, task:)
    @model = model
    @task = task
  end

  def test_set_evaluations
    @task.test_sets.includes(:entries)
      .map { |ts| TestSetEvaluation.new(@model, ts) }
  end
end
