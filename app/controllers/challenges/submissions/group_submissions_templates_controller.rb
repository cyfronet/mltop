module Challenges
  module Submissions
    class GroupSubmissionTemplatesController < ApplicationController
      def show
        @model = Current.user.models.find(params[:submission_id])
        filename = "submission_template_#{@model.name}.zip"
        zip_tempfile = GroupSubmissionTemplate.new(@model).create

        send_file zip_tempfile.path,
          type: "application/zip",
          filename:,
          disposition: "attachment"
      ensure
        zip_tempfile.close
        zip_tempfile.unlink
      end
    end
  end
end
