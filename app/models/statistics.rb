class Statistics
  def models
    Current.challenge.models.count
  end

  def test_sets
    Current.challenge.test_sets.count
  end

  def metrics
    Metric.joins(:evaluator)
      .where(evaluator: { challenge: Current.challenge })
      .distinct.count
  end
end
