class Model::TaskEvaluation::TestSetEvaluation
  def initialize(model, test_set)
    @model = model
    @test_set = test_set
  end

  def name = @test_set.name

  def hypothesis
    hypothesis = @model.hypothesis
      .select { |h| entries_ids.include? h.test_set_entry_id }
      .map { |h| [ h.test_set_entry_id, h ] }
      .to_h

    @test_set.entries.map { |e| hypothesis[e.id] || Hypothesis::Empty.new(@model, e) }
  end

  private
    def entries_ids
      @entries_ids ||= Set.new @test_set.entries.map(&:id)
    end
end
