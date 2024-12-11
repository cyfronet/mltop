require "test_helper"

class ExternalSubmissionsControllerTest < ActionDispatch::IntegrationTest
  test "Meetween member can manage external users submissions" do
    sign_in_as("marek")

    get external_submissions_path
    assert_response :success
  end

  test "External user cannot manage external users submissions" do
    sign_in_as("external", teams: [ "plggother" ])

    get external_submissions_path
    assert_response :redirect

    follow_redirect!
    assert_includes response.body, "Only Meetween members can manage"
  end

  test "Meetween member can see only not evaluated external models" do
    external_model = create_not_evaluated_model(owner: users("external"))
    internal_model = create_not_evaluated_model(owner: users("marek"))

    sign_in_as("marek")

    get external_submissions_path
    assert_includes response.body, external_model.name
    assert_not_includes response.body, internal_model.name
  end

  private
    def create_not_evaluated_model(owner:)
      create(:model, owner:).tap do |with_evaluation_pending|
        create(:hypothesis, model: with_evaluation_pending)
      end
    end
end
