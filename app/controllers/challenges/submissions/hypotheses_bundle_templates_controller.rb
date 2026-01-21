module Challenges
  module Submissions
    class HypothesesBundleTemplatesController < ApplicationController
      def show
        @model = Current.user.models.find(params[:submission_id])
        filename = "submission_template_#{@model.name}.zip"
        zip_data = HypothesesBundleTemplate.new(@model).generate

        send_data zip_data.read,
          type: "application/zip",
          filename:,
          disposition: "attachment"
      end
    end
  end
end
