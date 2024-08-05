# frozen_string_literal: true

require "test_helper"
require "ostruct"

module Plgrid
  class UserTest < ActiveSupport::TestCase
    test "plgrid login uses auth info to populate user data" do
      user = User.from_omniauth(auth("plgnewuser", token: CcmHelpers::VALID_TOKEN))

      attrs = {
        name: "plgnewuser Last Name",
        email: "plgnewuser@b.c",
        plgrid_login: "plgnewuser",
        ssh_key: CredentialsProvider.key,
        ssh_certificate: CredentialsProvider.cert
      }

      assert_equal attrs, user.attributes
    end

    test "nil proxy when openid connect token is not valid" do
      user = User.from_omniauth(auth("plgnewuser", token: "invalid"))

      attrs = user.attributes
      assert_nil attrs[:ssh_key]
      assert_nil attrs[:ssh_certificate]
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
end
