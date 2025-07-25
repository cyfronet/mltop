require "test_helper"

module Challenges
  class MembershipsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as("marek")
      in_challenge!
      @mandatory_consent = create(:consent, mandatory: true)
      @optional_consent = create(:consent, mandatory: false)
    end

    test "can get new membership form" do
      get new_membership_path
      assert_response :success
    end

    test "can create membership with mandatory consents agreed" do
      assert_difference "Membership.count", 1 do
        post membership_path(format: :turbo_stream), params: {
          membership: {
            agreements_attributes: [
              { consent_id: @mandatory_consent.id, agreed: true },
              { consent_id: @optional_consent.id, agreed: false }
            ]
          }
        }
      end
      assert_response :redirect
      assert_match "Successfully joined the challenge", flash[:notice]
    end

    test "cannot go to new membership if already a member" do
      create(:membership)
      get new_membership_path
      assert_response :redirect
      assert_equal "You're already a participant of this challenge.", flash[:alert]
    end

    test "cannot create membership if already a member" do
      create(:membership)
      assert_no_difference "Membership.count" do
        post membership_path, params: {
          membership: {
            agreements_attributes: [
              { consent_id: @mandatory_consent.id, agreed: true }
            ]
          }
        }
      end
      assert_response :redirect
      assert_equal "You're already a participant of this challenge.", flash[:alert]
    end

    test "fails to create membership without agreeing to mandatory consent" do
      assert_no_difference "Membership.count" do
        post membership_path, params: {
          membership: {
            agreements_attributes: [
              { consent_id: @mandatory_consent.id, agreed: false }
            ]
          }
        }
      end
      assert_response :unprocessable_entity
      assert_select "form"
    end

    test "fails to create membership if user does not have proper group" do
      challenges(:global).update(allowed_groups: [])
            assert_no_difference "Membership.count" do
        post membership_path, params: {
          membership: {
            agreements_attributes: [
              { consent_id: @mandatory_consent.id, agreed: false }
            ]
          }
        }
      end
      assert_response :unprocessable_entity
      assert_equal flash[:alert], "Couldn't join the challenge. You do not belong to allowed group within the challenge"
    end
  end
end
