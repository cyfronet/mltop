# frozen_string_literal: true

require "test_helper"
require "ostruct"

module Sso
  class PlgridTest < ActiveSupport::TestCase
    test "plgrid login uses auth info and CCM to populate user data for meetween members" do
      plgrid_user = Sso::Plgrid.from_omniauth(auth("plgnewuser",
        token: CcmHelpers::VALID_TOKEN,
        groups: [ "plggmeetween", "other", "group" ]))

      attrs = {
        name: "plgnewuser Last Name",
        email: "plgnewuser@b.c",
        plgrid_login: "plgnewuser",
        roles_mask: ::User.new(roles: [ :meetween_member ]).roles_mask,
        ssh_key: CredentialsProvider.key,
        ssh_certificate: CredentialsProvider.cert
      }

      assert_user_attrs_equal attrs, plgrid_user
    end

    test "plgrid login uses only auth info to populate user data for non-meetween members" do
      plgrid_user = Sso::Plgrid.from_omniauth(auth("plgnewuser",
        token: CcmHelpers::VALID_TOKEN,
        groups: [ "other", "group" ]))

      attrs = {
        name: "plgnewuser Last Name",
        email: "plgnewuser@b.c",
        plgrid_login: "plgnewuser",
        roles_mask: ::User.new(roles: []).roles_mask,
        ssh_key: nil,
        ssh_certificate: nil
      }

      assert_user_attrs_equal attrs, plgrid_user
    end

    test "nil proxy when openid connect token is not valid" do
      assert_raise ::Plgrid::Ccm::FetchError do
        Sso::Plgrid.from_omniauth(auth("plgnewuser", token: "invalid", groups: [ "plggmeetween" ]))
      end
    end

    test "meetween users has meetween_member role" do
      plgrid_user = Sso::Plgrid.from_omniauth(auth("plgnewuser",
        token: CcmHelpers::VALID_TOKEN, groups: [ "plggmeetween" ]))

      assert plgrid_user.to_user.meetween_member?
    end

    test "meetween_member role is removed when user does not belong to plggmeetween group" do
      user = create(:user, uid: "plgexisting_user", roles: [ :meetween_member ], provider: "plgrid")
      plgrid_user = Sso::Plgrid.from_omniauth(auth("plgexisting_user", token: CcmHelpers::VALID_TOKEN, groups: []))

      assert_equal user.id, plgrid_user.to_user.id
      assert_not plgrid_user.to_user.meetween_member?
    end

    test "non meetween users does not have meetween_member role" do
      plgrid_user = Sso::Plgrid.from_omniauth(auth("plgnewuser",
        token: CcmHelpers::VALID_TOKEN, groups: [ "plggother" ]))

      assert_not plgrid_user.to_user.meetween_member?
    end

    private
      def assert_user_attrs_equal(attrs, plgrid_user)
        user_attrs = plgrid_user.to_user.attributes
          .with_indifferent_access.slice(*attrs.keys)

        assert_equal attrs.with_indifferent_access, user_attrs
      end

      def auth(plglogin, token:, groups: [])
        OpenStruct.new(
          uid: plglogin,
          info: OpenStruct.new(
            nickname: plglogin,
            email: "#{plglogin}@b.c",
            name: "#{plglogin} Last Name"
          ),
          credentials: OpenStruct.new(
            token:
          ),
          extra: OpenStruct.new(
            raw_info: OpenStruct.new(groups:)
          )
        )
      end
  end
end
