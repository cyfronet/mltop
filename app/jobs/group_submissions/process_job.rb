module GroupSubmissions
  class ProcessJob < ApplicationJob
    queue_as :default

    def perform(group_submission_id)
      group_submission = GroupSubmission.find_by(id: group_submission_id)
      return unless group_submission

      GroupSubmissionProcessor.new(group_submission).process
    end
  end
end
