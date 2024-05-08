module TestSetsHelper
  def test_set_metric_order(subtask, metric)
    selected_order == "desc" ? "asc" : "desc" if subtask_metric_active?(subtask, metric)
  end

  def test_set_sort_chevron(subtask, metric)
    if subtask_metric_active?(subtask, metric)
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
    def subtask_metric_active?(subtask, metric)
      metric == selected_metric && subtask == selected_subtask
    end

    def aggregated_metric_active?(metric)
      metric == selected_metric && selected_subtask.nil?
    end
end
