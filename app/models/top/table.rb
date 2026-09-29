# frozen_string_literal: true

class Top::Table
  attr_reader :title, :test_set, :test_set_entry, :metrics, :rows

  def self.for_test_set(rows:, test_set:, test_set_entries:, metrics:)
    tables = [
      new(title: "Average", rows:, test_set:, metrics:)
    ]

    test_set_entries.each do |test_set_entry|
      tables << new(title: test_set_entry, rows:, test_set:, metrics:, test_set_entry:)
    end

    tables.reject(&:empty?)
  end

  def self.for_task(rows:, test_sets:, metrics:)
    test_sets.filter_map do |test_set|
      new(title: test_set, rows:, test_set:, metrics:).presence
    end
  end

  def initialize(title:, rows:, test_set:, metrics:, test_set_entry: nil)
    @title = title
    @test_set = test_set
    @test_set_entry = test_set_entry
    @metrics = metrics
    @rows = rows.select { |row| row.has_scores?(metrics:, test_set:, test_set_entry:) }
  end

  def empty? = rows.empty?

  def best_score?(row, metric)
    value = score(row, metric).effective_value
    value.present? && value == best_value(metric)
  end

  def top_row?(row)
    top_rows.include?(row)
  end

  private
    def top_rows
      @top_rows ||= begin
        wins = rows.index_with { |row| metrics.count { |metric| best_score?(row, metric) } }
        max = wins.values.max
        max.to_i.positive? ? wins.select { |_, count| count == max }.keys : []
      end
    end

    def score(row, metric)
      row.score(test_set:, metric:, test_set_entry:)
    end

    def best_value(metric)
      @best_values ||= metrics.index_with do |m|
        values = rows.filter_map { |row| score(row, m).effective_value }
        m.desc? ? values.max : values.min
      end
      @best_values[metric]
    end
end
