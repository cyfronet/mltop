class Model::TaskEvaluation
  def initialize(model:, task:)
    @model = model
    @task = task
  end

  def test_set_evaluations
    @task.test_sets.includes(:entries)
      .map { |ts| Model::TaskEvaluation::TestSetEvaluation.new(@model, ts) }
  end

  class TestSetEvaluation
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

      @test_set.entries.map { |e| hypothesis[e.id] || EmptyHypothesis.new(@model, e) }
    end

    private
      def entries_ids
        @entries_ids ||= Set.new @test_set.entries.map(&:id)
      end
  end

  class EmptyHypothesis
    attr_reader :test_set_entry

    def initialize(model, test_set_entry)
      @model = model
      @test_set_entry = test_set_entry
    end

    def to_s = @test_set_entry.to_s
    def model_id = @model.id
    def entry_id = @test_set_entry.id
    def to_partial_path = "submissions/hypotheses/empty_hypothesis"
  end
end
