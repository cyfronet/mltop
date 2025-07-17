module Top
  class Normalizer
    def initialize(rows)
      @rows = rows
      @relative = false
      @col_worstbest ||= {}
    end

    def normalize(value, test_set, metric, test_set_entry)
      return nil if value.nil?

      worst, best = col_worstbest(test_set:, metric:, test_set_entry:)
      self.class.normalize(value, best, worst, metric.asc?)
    end

    def relative!
      @relative = true
      @col_worstbest.clear
    end

    def self.normalize(value, best_score, worst_score, asc = false)
      return nil if value.nil?

      normalized = (value - worst_score) / (best_score - worst_score)
      normalized = 1.0 - normalized if asc

      normalized
    end

    def relative? = @relative

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
