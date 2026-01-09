
module Challenges
  module Submissions
    class HypothesesBundlesController < ApplicationController
      def create
        model = Current.challenge.models.find(params[:submission_id])
        @hypotheses_bundle = model.hypotheses_bundles.build(permitted_attributes(HypothesesBundle))
        authorize @hypotheses_bundle

        if @hypotheses_bundle.save
          @hypotheses_bundle.process_later
          redirect_to submission_path(@hypotheses_bundle.model), notice: "Group submission uploaded successfully, starting processing."
        else
          redirect_back fallback_location: submission_path(@hypotheses_bundle.model), alert: "We couldn't upload hypotheses bundle"
        end
      end
    end
  end
end
