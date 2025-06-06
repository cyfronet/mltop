require "test_helper"

class MembershipsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as("marek")
    in_challenge!
    @required_consent = create(:consent, required: true)
    @optional_consent = create(:consent, required: false)
  end

  test "can get new membership form" do
    get new_membership_path
    assert_response :success
  end

  test "can create membership with required consents agreed" do
    assert_difference "Membership.count", 1 do
      post membership_path(format: :turbo_stream), params: {
        membership: {
          agreements_attributes: [
            { consent_id: @required_consent.id, agreed: true },
            { consent_id: @optional_consent.id, agreed: false }
          ]
        }
      }
    end
    assert_response :success
    assert_match "Successfully joined challenge", flash[:notice]
  end

  test "cannot create membership if already a member" do
    create(:membership)
    assert_no_difference "Membership.count" do
      post membership_path, params: {
        membership: {
          agreements_attributes: [
            { consent_id: @required_consent.id, agreed: true }
          ]
        }
      }
    end
    assert_response :redirect
    assert_equal "Already member of this challenge.", flash[:alert]
  end

  test "fails to create membership without agreeing to required consent" do
    assert_no_difference "Membership.count" do
      post membership_path, params: {
        membership: {
          agreements_attributes: [
            { consent_id: @required_consent.id, agreed: false }
          ]
        }
      }
    end
    assert_response :unprocessable_entity
    assert_select "form"
  end
end
