class Top::Rows
  delegate_missing_to :@rows
  attr_reader :source_languages, :target_languages

  def initialize(rows, source_languages, target_languages, source, target)
    @rows = rows
    @source_languages = source_languages
    @target_languages = target_languages
    @source = source
    @target = target
  end

  def order(test_set:, metric:, order: "desc", test_set_entry: nil)
    if test_set && metric
      rows = @rows.sort do |a, b|
        a_val = a.score(test_set:, metric:, test_set_entry:).value
        b_val = b.score(test_set:, metric:, test_set_entry:).value

        next 1 if a_val.nil?
        next -1 if b_val.nil?

        # Reverse with XOR if we want descending OR the metric prefers lower scores
        if (order == "desc") ^ metric.asc?
          b_val <=> a_val
        else
          a_val <=> b_val
        end
      end

      Top::Rows.new(rows, source_languages, target_languages, @source, @target)
    else
      self
    end
  end

  def average?
    (@source.blank? && source_languages.size > 1) ||
      (@target.blank? && target_languages.size > 1)
  end
end
