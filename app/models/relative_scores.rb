class RelativeScores
  def initialize(rows, test_sets, metrics, test_set_entries = nil)
    @rows = rows
    @test_sets = test_sets
    @metrics = metrics
    @test_set_entries = test_set_entries
    gather_best_and_worst_scores
  end

  def best_score_for(metric, test_set, test_set_entry = nil)
    if test_set_entry
      @relative_scores[metric][test_set][test_set_entry][:best]&.value
    else
      @relative_scores[metric][test_set][:best]&.value
    end
  end

  def worst_score_for(metric, test_set, test_set_entry = nil)
    if test_set_entry
      @relative_scores[metric][test_set][test_set_entry][:worst]&.value
    else
      @relative_scores[metric][test_set][:worst]&.value
    end
  end

  private
    def gather_best_and_worst_scores
      @relative_scores = {}
      @metrics.each do |metric|
        @relative_scores[metric] = {}
        @test_sets.each do |test_set|
          @relative_scores[metric][test_set] = {}
          scores = @rows.map { |row| row.score(test_set:, metric:) }.reject { |score| score.value.nil? }
          if metric.desc?
            @relative_scores[metric][test_set][:best] = scores.max_by(&:value)
            @relative_scores[metric][test_set][:worst] = scores.min_by(&:value)
          else
            @relative_scores[metric][test_set][:best] = scores.min_by(&:value)
            @relative_scores[metric][test_set][:worst] = scores.max_by(&:value)
          end

          gather_best_and_worst_scores_for_entries(metric, test_set) if @test_set_entries
        end
      end
    end

    def gather_best_and_worst_scores_for_entries(metric, test_set)
      @test_set_entries.each do |test_set_entry|
        @relative_scores[metric][test_set][test_set_entry] = {}
        entry_scores = @rows.map { |row| row.score(test_set:, metric:, test_set_entry:) }.reject { |score| score.value.nil? }
        if metric.desc?
          @relative_scores[metric][test_set][test_set_entry][:best] = entry_scores.max_by(&:value)
          @relative_scores[metric][test_set][test_set_entry][:worst] = entry_scores.min_by(&:value)
        else
          @relative_scores[metric][test_set][test_set_entry][:best] = entry_scores.min_by(&:value)
          @relative_scores[metric][test_set][test_set_entry][:worst] = entry_scores.max_by(&:value)
        end
      end
    end
end
