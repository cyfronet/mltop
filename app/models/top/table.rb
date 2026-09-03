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
end
