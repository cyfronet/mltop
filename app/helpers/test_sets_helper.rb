module TestSetsHelper
  def test_set_metric_order(test_set_entry, metric)
    selected_order == "desc" ? "asc" : "desc" if test_set_entry_metric_active?(test_set_entry, metric)
  end

  def test_set_sort_chevron(test_set_entry, metric)
    if test_set_entry_metric_active?(test_set_entry, metric)
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
    def test_set_entry_metric_active?(test_set_entry, metric)
      metric == selected_metric && test_set_entry == selected_test_set_entry
    end

    def aggregated_metric_active?(metric)
      metric == selected_metric && selected_test_set_entry.nil?
    end
end
