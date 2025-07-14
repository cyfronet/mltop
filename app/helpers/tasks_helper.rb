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

  def interpolate_color(metric_value, metric, test_set, test_set_entry = nil)
    return "rgb(156, 163, 175)" unless metric_value

    @normalizer ||= Normalizer.new(@rows, params[:color])
    normalized = @normalizer.normalize(metric_value, test_set, metric, test_set_entry)

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

  private
    def test_set_metric_active?(test_set, metric)
      metric == selected_metric && test_set == selected_test_set
    end

    class Normalizer
      def initialize(rows, color_schema)
        @rows = rows
        @relative = color_schema == "relative"
        @col_worstbest ||= {}
      end

      def normalize(value, test_set, metric, test_set_entry)
        worst, best = col_worstbest(test_set:, metric:, test_set_entry:)
        normalized = (value - worst) / (best - worst)
        normalized = 1.0 - normalized if metric.asc?

        normalized
      end

      private
        def relative? = @relative

        def col_worstbest(test_set:, metric:, test_set_entry: nil)
          @col_worstbest ||= {}
          @col_worstbest[[ test_set, metric, test_set_entry ]] ||=
            calculate_col_worstbest(test_set:, metric:, test_set_entry:)
        end

        def calculate_col_worstbest(test_set:, metric:, test_set_entry: nil)
          if relative?
            minmax = @rows
                    .map { |row| row.score(test_set:, metric:, test_set_entry:).value }
                    .compact
                    .minmax

            metric.asc? ? minmax.reverse : minmax
          else
            [ metric.worst_score, metric.best_score ]
          end
        end
    end
end
