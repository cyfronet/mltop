module TasksHelper
  def metric_order(test_set, metric)
    selected_order == "desc" ? "asc" : "desc" if test_set_metric_active?(test_set, metric)
  end

  def sort_chevron(test_set, metric)
    if test_set_metric_active?(test_set, metric)
      selected_order == "desc" ? chevron_down : chevron_up
    else
      chevron_updown
    end
  end

  private
    def test_set_metric_active?(test_set, metric)
      metric == selected_metric && test_set == selected_test_set
    end

  def interpolate_color(metric_value, metric)
    worst = metric.worst_score
    best = metric.best_score
    value = metric_value || worst

    normalized = (value - worst) / (best - worst)
    normalized = 1.0 - normalized if metric.asc?

    red = [ 220, 38, 38 ] # red-600
    yellow = [ 251, 191, 36 ] # yellow-400
    green = [ 4, 120, 87 ] # green-700

    if normalized <= 0.5
      ratio = normalized / 0.5
      r = (red[0] + ratio * (yellow[0] - red[0])).to_i
      g = (red[1] + ratio * (yellow[1] - red[1])).to_i
      b = (red[2] + ratio * (yellow[2] - red[2])).to_i
    else
      ratio = (normalized - 0.5) / 0.5
      r = (yellow[0] + ratio * (green[0] - yellow[0])).to_i
      g = (yellow[1] + ratio * (green[1] - yellow[1])).to_i
      b = (yellow[2] + ratio * (green[2] - yellow[2])).to_i
    end

    "rgb(#{r}, #{g}, #{b})"
  end
end
