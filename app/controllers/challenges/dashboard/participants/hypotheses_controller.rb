module Challenges
  module Dashboard
    module Participants
      class HypothesesController < ApplicationController
        def index
          @participant = User.find(params[:participant_id])

          send_file @participant.all_hypothesis(Current.challenge.id),
          type: "application/zip", filename: "user-#{@participant.id}-hypotheses.zip"
        end
      end
    end
  end
end
