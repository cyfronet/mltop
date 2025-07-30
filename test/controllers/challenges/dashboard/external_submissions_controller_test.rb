require "test_helper"

module Challenges
  module Dashboard
    class ExternalSubmissionsControllerTest < ActionDispatch::IntegrationTest
      test "Challenge manager can manage external users submissions" do
        sign_in_as("marek")
        in_challenge!(users(:marek), :manager)

        get dashboard_external_submissions_path
        assert_response :success
      end

      test "External user cannot manage external users submissions" do
        sign_in_as("external", teams: [ "plggother" ])
        in_challenge!(users(:external))

        get dashboard_external_submissions_path
        assert_redirected_to root_path
      end

      test "Challenge manager can see only not evaluated external models" do
        empty_external_model = create(:model, owner: users("external"))
        external_model = create_not_evaluated_model(owner: users("external"))
        internal_model = create_not_evaluated_model(owner: users("marek"))

        sign_in_as("marek")
        in_challenge!(users(:marek), :manager)

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
