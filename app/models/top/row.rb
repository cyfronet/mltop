class Top::Row
  private_class_method :new

  attr_reader :model

  delegate :name, to: :model

  def initialize(model, scores, groundtruths_counts)
    @model = model
    @scores = scores
    @groundtruths_counts = groundtruths_counts
    @cached_scores = {}
  end

  def self.where(task:, test_set: nil)
    scores = Score
      .joins(evaluation: { hypothesis: { groundtruth: [ :test_set_entry ] } })
      .where(evaluation: { hypotheses: { groundtruths: { task_id: task } } })
    scores = scores.where(evaluation: { hypotheses: { groundtruths: { test_set_entries: { test_set_id: test_set } } } }) if test_set

    scores = scores.select("scores.value, scores.metric_id, hypotheses.model_id, test_set_entries.test_set_id, groundtruths.id as groundtruth_id")
    groundtruths_counts = task.groundtruths.includes(:test_set_entry)
                            .group_by { |gt| gt.test_set_entry.test_set_id }
                            .transform_values(&:size)

    scores_by_model_id = scores.group_by { |score| score.model_id }
    models = Model.where(id: scores_by_model_id.keys).index_by(&:id)
    rows = scores_by_model_id.map { |model_id, scores| new(models[model_id], scores, groundtruths_counts) }

    Top::Rows.new(rows)
  end

  def score(test_set:, metric:, groundtruth: nil)
    @cached_scores[[ test_set, metric, groundtruth ]] ||= calculate_score(test_set:, metric:, groundtruth:)
  end

  def calculate_score(test_set:, metric:, groundtruth: nil)
    scores = @scores.filter do |score|
      (!test_set || score.test_set_id == test_set.id) &&
        (!metric || score.metric_id == metric.id)
    end

    scores = if groundtruth
      scores.filter { |score| score.groundtruth_id == groundtruth.id }
    else
      scores
        .group_by { |score| [ score.metric_id, score.test_set_id ] }
        .values.map do |list|
          Score.new(metric:, value: list.sum(&:value) / @groundtruths_counts[test_set.id])
        end
    end

    case scores.count
    when 1 then scores.first
    when 0 then Score.new(metric:, value: nil)
    when 2.. then raise ActiveSupport::EnumerableCoreExt::SoleItemExpectedError, "multiple items found"
    end
  end
end
