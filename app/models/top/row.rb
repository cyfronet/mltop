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

  def self.where(task:, test_set: nil, source: nil, target: nil)
    scores = Score
      .joins(:metric, evaluation: { hypothesis: { test_set_entry: :task_test_set } })
      .where(evaluation: { hypotheses: { test_set_entries: { task_test_sets: { task_id: task } } } })
    scores = scores.where(evaluation: { hypotheses: { test_set_entries: { task_test_sets: { test_set_id: test_set } } } }) if test_set
    scores = scores.where(evaluation: { hypotheses: { test_set_entries: { source_language: source } } }) unless source.blank?
    scores = scores.where(evaluation: { hypotheses: { test_set_entries: { target_language: target } } }) unless target.blank?

    scores = scores.select("scores.value, scores.metric_id, hypotheses.model_id, task_test_sets.test_set_id, test_set_entries.id as test_set_entry_id, metrics.worst_score as metric_worst_score")

    entries = task.test_set_entries
    entries = entries.where(source_language: source) unless source.blank?
    entries = entries.where(target_language: target) unless target.blank?
    entries_counts = entries.group("test_set_id").count

    scores_by_model_id = scores.group_by { |score| score.model_id }
    models = Model.where(id: scores_by_model_id.keys).index_by(&:id)
    rows = scores_by_model_id.map { |model_id, scores| new(models[model_id], scores, entries_counts) }

    entries = task.test_set_entries
    entries = entries.joins(:task_test_set).where(task_test_set: { test_set: }) if test_set

    source_languages, target_languages = entries
      .pluck(:source_language, :target_language)
      .transpose.map(&:uniq)

    Top::Rows.new(rows, source_languages, target_languages, source, target)
  end

  def self.none
    Top::Rows.new([], [], [], nil, nil)
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
          Score.new(metric:, value: list.sum { |item| item.value || item.metric_worst_score } / @entries_counts[test_set.id])
        end
    end

    case scores.count
    when 1 then scores.first
    when 0 then Score.new(metric:, value: nil)
    when 2.. then raise ActiveSupport::EnumerableCoreExt::SoleItemExpectedError, "multiple items found"
    end
  end
end
