
class Hypothesis::Broadcaster
  def initialize(hypothesis)
    @hypothesis = hypothesis
  end

  def broadcast_change
    Turbo::StreamsChannel.broadcast_replace_to(
      stream_name,
      target:,
      partial: partial_path,
      locals: { hypothesis:  }
    )
  end

  def broadcast_delete
    Turbo::StreamsChannel.broadcast_replace_to(
      stream_name,
      target:,
      partial: empty_hypothesis_partial_path,
      locals: { empty_hypothesis: empty_hypothesis }
    )
  end

  def broadcast_scores
    Turbo::StreamsChannel.broadcast_replace_to(
      stream_name,
      target:
      ActionView::RecordIdentifier.dom_id(hypothesis.test_set_entry),
      partial: "submissions/hypotheses/hypothesis",
      locals: { hypothesis: hypothesis }
    )
  end

  private

  attr_reader :hypothesis

  def stream_name
    [ hypothesis.model, hypothesis.test_set_entry.task ]
  end

  def target
    ActionView::RecordIdentifier.dom_id(hypothesis.test_set_entry)
  end

  def partial_path
    "submissions/hypotheses/hypothesis"
  end

  def empty_hypothesis_partial_path
    "submissions/hypotheses/empty_hypothesis"
  end

  def empty_hypothesis
    Hypothesis::Empty.new(hypothesis.model, hypothesis.test_set_entry)
  end
end
