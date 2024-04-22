module ModelTypesHelper
  def metric_order(metric)
    selected_order == "desc" ? "asc" : "desc" if metric == selected_metric
  end

  def sort_chevron(metric)
    if metric == selected_metric
      selected_order == "desc" ? chevron_down : chevron_up
    else
      chevron_updown
    end
  end
end
