class Admin::Participants::HypothesesController < Admin::ApplicationController
  def index
    @participant = User.find(params[:participant_id])

    send_file @participant.all_hypothesis,
      type: "application/zip", filename: "user-#{@participant.id}-hypotheses.zip"
  end
end
