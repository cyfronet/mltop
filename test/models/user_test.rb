# frozen_string_literal: true

require "test_helper"
require "ostruct"

CcmHelpers.default_ccm_stubs!

class UserTest < ActiveSupport::TestCase
  test "plgrid login uses auth info to populate user data" do
    user = User.from_plgrid_omniauth(auth("plgnewuser", token: CcmHelpers::VALID_TOKEN))

    assert_equal "plgnewuser", user.plgrid_login
    assert_equal "plgnewuser@b.c", user.email
    assert_equal "plgnewuser Last Name", user.name
    assert_equal CredentialsProvider.key, user.ssh_key
    assert_equal CredentialsProvider.cert, user.ssh_certificate
  end

  test "nil proxy when openid connect token is not valid" do
    user = User.from_plgrid_omniauth(auth("plgnewuser", token: "invalid"))

    assert_nil user.ssh_key
    assert_nil user.ssh_certificate
  end

  private
    def auth(plglogin, token:)
      OpenStruct.new(
        info: OpenStruct.new(
          nickname: plglogin,
          email: "#{plglogin}@b.c",
          name: "#{plglogin} Last Name"
        ),
        credentials: OpenStruct.new(
          token:
        )
      )
    end
end
