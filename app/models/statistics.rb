class Statistics
  def models
    Model.count
  end

  def test_sets
    TestSet.count
  end

  def metrics
    Metric.count
  end
end
