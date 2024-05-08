module ModelTypesHelper
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
end
