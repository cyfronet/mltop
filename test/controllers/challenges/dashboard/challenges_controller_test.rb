require "test_helper"

class Challenges::Dashboard::ChallengesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  def setup
    @challenge = challenges(:global)
    in_challenge!
  end

  test "#edit denied access for normal user" do
    sign_in_as(:external, teams: nil)
    get edit_dashboard_challenge_path(@challenge)

    assert_response :redirect
    assert_equal "You are not authorized to perform this action", flash[:alert]
  end

  test "#edit for admin" do
    sign_in_as(:marek)
    Membership.find_by(user: users(:marek), challenge: challenges(:global)).update(roles: [ :admin ])
    get edit_dashboard_challenge_path(@challenge)

    assert_response :success
  end

  test "should update challenge" do
    sign_in_as(:marek)
    Membership.find_by(user: users(:marek), challenge: challenges(:global)).update(roles: [ :admin ])
    patch dashboard_challenge_path(@challenge), params: { challenge: { name: "updated name" } }
    assert_redirected_to challenge_path(@challenge)
    assert_equal @challenge.reload.name, "updated name"
  end

  test "should destroy challenge" do
    sign_in_as(:marek)
    Membership.find_by(user: users(:marek), challenge: challenges(:global)).update(roles: [ :admin ])
    assert_difference("Challenge.count", -1) do
      delete dashboard_challenge_path(@challenge)
    end

    assert_redirected_to challenges_path
  end
end
