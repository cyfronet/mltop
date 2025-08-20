require "test_helper"

class Challenges::Dashboard::ChallengesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  def setup
    @challenge = challenges(:global)
    in_challenge!
  end

  test "#edit denied access for normal user" do
    challenge_member_signs_in(:external, @challenge)
    get edit_dashboard_challenge_path(@challenge)

    assert_response :redirect
    assert_equal "You are not authorized to perform this action", flash[:alert]
  end

  test "#edit for manager admin" do
    challenge_member_signs_in(:marek, @challenge, teams: [ "plggmeetween" ])
    grant_admin_access_to(:marek, challenges(:global))

    get edit_dashboard_challenge_path(@challenge)

    assert_response :success
  end

  test "should update challenge for admin" do
    challenge_member_signs_in(:marek, @challenge, teams: [ "plggmeetween" ])
    grant_admin_access_to(:marek, challenges(:global))

    patch dashboard_challenge_path(@challenge), params: { challenge: { name: "updated name" } }
    assert_redirected_to edit_dashboard_challenge_path(@challenge)
    assert_equal @challenge.reload.name, "updated name"
  end

  test "should destroy challenge for admin" do
    challenge_member_signs_in(:marek, @challenge, teams: [ "plggmeetween" ])
    grant_admin_access_to(:marek, challenges(:global))

    assert_difference("Challenge.count", -1) do
      delete dashboard_challenge_path(@challenge)
    end

    assert_redirected_to challenges_path
  end
end
