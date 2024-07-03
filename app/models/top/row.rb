class Top::Row
  private_class_method :new

  attr_reader :model

  delegate :name, to: :model

  def initialize(model, scores, subtasks_count)
    @model = model
    @scores = scores
    @subtasks_count = subtasks_count
    @cached_scores = {}
  end

  def self.where(task:, test_set: nil)
    scores = Score
      .joins(evaluation: { hypothesis: { groundtruth: [ :subtask, :test_set_entry ] } })
      .where(evaluation: { hypotheses: { groundtruths: { subtasks: { task_id: task } } } })
    scores = scores.where(evaluation: { hypotheses: { groundtruths: { test_set_entities: { test_set_id: test_set } } } }) if test_set

    scores = scores.select("scores.value, scores.metric_id, hypotheses.model_id, groundtruths.subtask_id, test_set_entries.test_set_id")
    subtasks_count = task.subtasks.size

    scores_by_model_id = scores.group_by { |score| score.model_id }
    models = Model.where(id: scores_by_model_id.keys).index_by(&:id)
    rows = scores_by_model_id.map { |model_id, scores| new(models[model_id], scores, subtasks_count) }

    Top::Rows.new(rows)
  end

  def score(test_set:, metric:, subtask: nil)
    @cached_scores[[ test_set, metric, subtask ]] ||= calculate_score(test_set:, metric:, subtask:)
  end

  def calculate_score(test_set:, metric:, subtask: nil)
    scores = @scores.filter do |score|
      (!test_set || score.test_set_id == test_set.id) &&
        (!metric || score.metric_id == metric.id)
    end

    scores = if subtask
      scores.filter { |score| score.subtask_id == subtask.id }
    else
      scores
        .group_by { |score| [ score.metric_id, score.test_set_id ] }
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
