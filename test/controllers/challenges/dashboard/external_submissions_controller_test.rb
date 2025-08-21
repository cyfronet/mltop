require "test_helper"

module Challenges
  module Dashboard
    class ExternalSubmissionsControllerTest < ActionDispatch::IntegrationTest
      test "Challenge manager can manage external users submissions" do
        challenge_member_signs_in("marek", challenges(:global), teams: [ "plggmeetween" ])

        get dashboard_external_submissions_path
        assert_response :success
      end

      test "External user cannot manage external users submissions" do
        sign_in_as("external", teams: [ "plggother" ])
        in_challenge!

        get dashboard_external_submissions_path
        assert_redirected_to root_path
      end

      test "Challenge manager can see only not evaluated external models" do
        users("marek").update(groups: [ "plggmeetween" ])
        users("external").update(groups: [ "plggother" ])
        create(:membership, user: users("marek"), challenge: challenges(:global), roles: [ :manager ])
        build(:membership, user: users("external"), challenge: challenges(:global), roles: []).save(validate: false)

        empty_external_model = create(:model, owner: users("external"))
        external_model = create_not_evaluated_model(owner: users("external"))
        internal_model = create_not_evaluated_model(owner: users("marek"))

        challenge_member_signs_in("marek", challenges(:global), teams: [ "plggmeetween" ])

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
