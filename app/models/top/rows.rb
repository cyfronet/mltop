class Top::Rows
  delegate_missing_to :@rows

  def initialize(rows)
    @rows = rows
  end

  def order(test_set:, metric:, order: "desc", test_set_entry: nil)
    if test_set && metric
      rows = @rows.sort do |a, b|
        a, b = b, a if order == "desc"
        a, b = b, a if metric.asc?

        a.score(test_set:, metric:, test_set_entry:).value <=>
          b.score(test_set:, metric:, test_set_entry:).value
      end

      Top::Rows.new(rows)
    else
      self
    end
  end
end
