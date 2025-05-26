
class Evaluations::Broadcaster
  def initialize(evaluation)
    @evaluation = evaluation
  end

  def broadcast_scores
    Turbo::StreamsChannel.broadcast_replace_to(
      [evaluation.hypothesis.model, evaluation.hypothesis.test_set_entry.task],
      target: ActionView::RecordIdentifier.dom_id(evaluation, "scores"),
      partial: "submissions/evaluations/scores",
      locals: { evaluation: }
    )
  end

  private

  attr_reader :evaluation
end
