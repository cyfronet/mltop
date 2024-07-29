module TestSetsHelper
  def test_set_metric_order(groundtruth, metric)
    selected_order == "desc" ? "asc" : "desc" if groundtruth_metric_active?(groundtruth, metric)
  end

  def test_set_sort_chevron(groundtruth, metric)
    if groundtruth_metric_active?(groundtruth, metric)
      selected_order == "desc" ? chevron_down : chevron_up
    else
      chevron_updown
    end
  end

  def aggregated_metric_order(metric)
    selected_order == "desc" ? "asc" : "desc" if aggregated_metric_active?(metric)
  end

  def aggregated_metric_sort_chevron(metric)
    if aggregated_metric_active?(metric)
      selected_order == "desc" ? chevron_down : chevron_up
    else
      chevron_updown
    end
  end

  private
    def groundtruth_metric_active?(groundtruth, metric)
      metric == selected_metric && groundtruth == selected_groundtruth
    end

    def aggregated_metric_active?(metric)
      metric == selected_metric && selected_groundtruth.nil?
    end
end
