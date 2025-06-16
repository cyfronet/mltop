require "test_helper"

module Challenges
  module Dashboard
    class ExternalSubmissionsControllerTest < ActionDispatch::IntegrationTest
      def setup
        in_challenge!
      end

      test "Meetween member can manage external users submissions" do
        sign_in_as("marek")

        get dashboard_external_submissions_path
        assert_response :success
      end

      test "External user cannot manage external users submissions" do
        sign_in_as("external", teams: [ "plggother" ])

        get dashboard_external_submissions_path
        assert_redirected_to root_path
      end

      test "Meetween member can see only not evaluated external models" do
        empty_external_model = create(:model, owner: users("external"))
        external_model = create_not_evaluated_model(owner: users("external"))
        internal_model = create_not_evaluated_model(owner: users("marek"))

        sign_in_as("marek")

        get dashboard_external_submissions_path
        assert_includes response.body, external_model.name
        assert_not_includes response.body, empty_external_model.name
        assert_not_includes response.body, internal_model.name
      end

      private
        def create_not_evaluated_model(owner:)
          create(:model, owner:).tap do |model|
            create(:hypothesis, model:)
          end
        end
    end
  end
end
