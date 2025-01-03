class Top::Row
  private_class_method :new

  attr_reader :model

  delegate :name, to: :model

  def initialize(model, scores, entries_counts)
    @model = model

    @scores = scores.group_by { |s| [ s.test_set_id, s.metric_id ] }
    @scores.default = []

    @entries_counts = entries_counts
    @cached_scores = {}
  end

  def self.where(task:, test_set: nil)
    scores = Score
      .joins(evaluation: { hypothesis: :test_set_entry })
      .where(evaluation: { hypotheses: { test_set_entries: { task_id: task } } })
    scores = scores.where(evaluation: { hypotheses: { test_set_entries: { test_set_id: test_set } } }) if test_set

    scores = scores.select("scores.value, scores.metric_id, hypotheses.model_id, test_set_entries.test_set_id, test_set_entries.id as test_set_entry_id")
    entries_counts = task.test_set_entries.group("test_set_id").count
    scores_by_model_id = scores.group_by { |score| score.model_id }
    models = Model.where(id: scores_by_model_id.keys).index_by(&:id)
    rows = scores_by_model_id.map { |model_id, scores| new(models[model_id], scores, entries_counts) }

    Top::Rows.new(rows)
  end

  def score(test_set:, metric:, test_set_entry: nil)
    @cached_scores[[ test_set, metric, test_set_entry ]] ||= calculate_score(test_set:, metric:, test_set_entry:)
  end

  def calculate_score(test_set:, metric:, test_set_entry: nil)
    scores = @scores[[ test_set.id, metric.id ]]

    scores = if test_set_entry
      scores.filter { |score| score.test_set_entry_id == test_set_entry.id }
    else
      scores
        .group_by { |score| [ score.metric_id, score.test_set_id ] }
        .values.map do |list|
          Score.new(metric:, value: list.sum(&:value) / @entries_counts[test_set.id])
        end
    end

    case scores.count
    when 1 then scores.first
    when 0 then Score.new(metric:, value: nil)
    when 2.. then raise ActiveSupport::EnumerableCoreExt::SoleItemExpectedError, "multiple items found"
    end
  end
end
