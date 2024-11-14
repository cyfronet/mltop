class Hypothesis::Empty
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
