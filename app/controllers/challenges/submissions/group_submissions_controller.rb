
module Challenges
  module Submissions
    class GroupSubmissionsController < ApplicationController
      def create
        model = Current.challenge.models.find(params[:submission_id])
        @group_submission = GroupSubmission.new(
          permitted_attributes(GroupSubmission).merge(
            user: Current.user,
            challenge: Current.challenge,
            model:,
            name: "#{model.name} #{DateTime.now.strftime("%Y%m%d%H%M%S")}"
          )
        )
        authorize @group_submission

        if @group_submission.save
          @group_submission.process_later
          redirect_to submission_path(@group_submission.model), notice: "Group submission uploaded successfully, starting processing."
        else
          redirect_back fallback_location: submission_path(@group_submission.model), alert: "We couldn't upload group submission"
        end
      end
    end
  end
end
