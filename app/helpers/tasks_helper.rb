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
      value = metric_value ? [ 0, [ 100, metric_value ].min ].max : 0
      value = 100 - value if metric.asc?
      red = [ 255, 0, 0 ]
      yellow = [ 255, 255, 0 ]
      green = [ 0, 255, 0 ]

      # Interpolate between red and yellow
      if value <= 50
          ratio = value / 50.0
          r = (red[0] + ratio * (yellow[0] - red[0])).to_i
          g = (red[1] + ratio * (yellow[1] - red[1])).to_i
          b = (red[2] + ratio * (yellow[2] - red[2])).to_i
      # Interpolate between yellow and green
      else
          ratio = (value - 50) / 50.0
          r = (yellow[0] + ratio * (green[0] - yellow[0])).to_i
          g = (yellow[1] + ratio * (green[1] - yellow[1])).to_i
          b = (yellow[2] + ratio * (green[2] - yellow[2])).to_i
      end

      "rgb(#{r}, #{g}, #{b})"
  end
end
