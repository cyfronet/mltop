require "test_helper"

class ChallengesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  def setup
    @challenge = create(:challenge)
  end
  test "#index" do
    sign_in_as(:marek)
    get challenges_path
    assert_response :success
    assert_includes response.body, @challenge.name
  end

  test "#show" do
    sign_in_as(:marek)
    get challenge_path(@challenge)
    assert_response :success
    assert_includes response.body, @challenge.name
end
  test "#new denied access for normal user" do
    sign_in_as(:external, teams: nil)
    get new_challenge_path

    assert_response :redirect
    assert_equal "You are not authorized to perform this action", flash[:alert]
  end

  test "#new for meetween member" do
    sign_in_as(:marek)
    get new_challenge_path

    assert_response :success
  end

  test "#create for meetween member" do
    sign_in_as(:marek)
    challenge = build(:challenge)

    assert_difference("Challenge.count") do
      post challenges_path, params: { challenge: {
        name: challenge.name,  description: challenge.description,
        starts_at: challenge.starts_at, ends_at: challenge.ends_at,
        owner_id: users(:marek).id
      } }
    end

    assert_redirected_to challenge_path(Challenge.last)
  end

  test "#edit denied access for normal user" do
    sign_in_as(:external, teams: nil)
    get edit_challenge_path(@challenge)

    assert_response :redirect
    assert_equal "You are not authorized to perform this action", flash[:alert]
  end

  test "#edit for meetween member" do
    sign_in_as(:marek)
    get edit_challenge_path(@challenge)

    assert_response :success
  end

  test "should update challenge" do
    sign_in_as(:marek)
    patch challenge_path(@challenge), params: { challenge: { name: "updated name" } }
    assert_redirected_to challenge_path(@challenge)
    assert_equal @challenge.reload.name, "updated name"
  end

  test "should destroy challenge" do
    sign_in_as(:marek)
    assert_difference("Challenge.count", -1) do
      delete challenge_path(@challenge)
    end

    assert_redirected_to challenges_path
  end
end
