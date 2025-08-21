# frozen_string_literal: true

require "test_helper"
require "ostruct"

module Sso
  class PlgridTest < ActiveSupport::TestCase
    test "plgrid login uses auth info and CCM to populate user data" do
      plgrid_user = Sso::Plgrid.from_omniauth(auth("plgnewuser",
        token: CcmHelpers::VALID_TOKEN,
        groups: [ "group1", "group2" ]))

      attrs = {
        name: "plgnewuser Last Name",
        email: "plgnewuser@b.c",
        plgrid_login: "plgnewuser",
        ssh_key: CredentialsProvider.key,
        ssh_certificate: CredentialsProvider.cert
      }

      assert_user_attrs_equal attrs, plgrid_user
    end

    test "nil proxy when openid connect token is not valid" do
      assert_raise ::Plgrid::Ccm::FetchError do
        Sso::Plgrid.from_omniauth(auth("plgnewuser", token: "invalid", groups: [ "plggmeetween" ]))
      end
    end

    test "groups are membership are updated when user groups change" do
      user = create(:user, uid: "plgexisting_user", groups: [ "plggmeetween" ], provider: "plgrid")
      membership = create(:membership, user:, challenge: challenges(:global), roles: [ :manager ])

      Sso::Plgrid.from_omniauth(auth("plgexisting_user", token: CcmHelpers::VALID_TOKEN, groups: [ "plgggemini" ])).to_user
      assert_equal [ "plgggemini" ], user.reload.groups
      assert_not membership.reload.has_role?(:manager)
    end

    test "membership is deleted when user no longer has required group" do
      user = create(:user, uid: "plgexisting_user", groups: [ "plggmeetween" ], provider: "plgrid")
      create(:membership, user:, challenge: challenges(:global), roles: [ :manager ])

      Sso::Plgrid.from_omniauth(auth("plgexisting_user", token: CcmHelpers::VALID_TOKEN, groups: [])).to_user
      assert_empty user.reload.groups
      assert_empty user.memberships
    end

    test "membership is upgraded when user has required group" do
      user = create(:user, uid: "plgexisting_user", groups: [ "plgggemini" ], provider: "plgrid")
      membership = create(:membership, user:, challenge: challenges(:global), roles: [ :participant ])

      Sso::Plgrid.from_omniauth(auth("plgexisting_user", token: CcmHelpers::VALID_TOKEN, groups: [ "plggmeetween" ])).to_user
      assert_equal [ "plggmeetween" ], user.reload.groups
      assert membership.reload.has_role?(:manager)
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
