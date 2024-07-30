class Top::Rows
  delegate_missing_to :@rows

  def initialize(rows)
    @rows = rows
  end

  def order(test_set:, metric:, order: "desc", groundtruth: nil)
    if test_set && metric
      rows = @rows.sort do |a, b|
        a, b = b, a if order == "desc"
        a.score(test_set:, metric:, groundtruth:).value <=>
          b.score(test_set:, metric:, groundtruth:).value
      end

      Top::Rows.new(rows)
    else
      self
    end
  end
end
