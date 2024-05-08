class Top::Row
  private_class_method :new

  attr_reader :model

  delegate :name, to: :model

  def initialize(model, scores, subtasks_count)
    @model = model
    @scores = scores
    @subtasks_count = subtasks_count
  end

  def self.where(task:)
    scores = Score
      .includes(evaluation: { subtask_test_set: :test_set, model: {} })
      .joins(metric: :evaluator).where(evaluation: { subtask_test_sets: { test_sets: { task_id: task } } })

    subtasks_count = task.subtasks.size

    rows = scores
            .group_by { |score| score.evaluation.model }
            .map { |model, scores| new(model, scores, subtasks_count) }

    Top::Rows.new(rows)
  end

  def score(test_set:, metric:, subtask: nil)
    scores = @scores.filter do |score|
      (!test_set || score.evaluation.subtask_test_set.test_set_id == test_set.id) &&
        (!metric || score.metric_id == metric.id)
    end

    scores = if subtask
      scores.filter { |score| score.evaluation.subtask_test_set.subtask_id == subtask.id }
    else
      scores
        .group_by { |score| [ score.metric_id, score.evaluation.subtask_test_set.test_set_id ] }
        .values.map do |list|
          Score.new(metric:, value: list.sum(&:value) / @subtasks_count)
        end
    end

    case scores.count
    when 1 then scores.first
    when 0 then Score.new(metric:, value: nil)
    when 2.. then raise ActiveSupport::EnumerableCoreExt::SoleItemExpectedError, "multiple items found"
    end
  end
end
