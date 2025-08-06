require "test_helper"

module Memberships
  class UpdateRolesTest < ActiveSupport::TestCase
    setup do
      @challenge = create(:challenge)
      @access_rule = create(:access_rule, challenge: @challenge, group_name: "old name", roles: [ :manager ])
      @user = create(:user, groups: [ "old name" ])
      @membership = create(:membership, user: @user, challenge: @challenge, roles: [ :manager ])
    end


    test "membership should be deleted when it was only one granting user access" do
      @access_rule.update(group_name: "new name")

      assert_changes "Membership.count", -1 do
        Memberships::UpdateRoles.new(challenge: @challenge.reload).call
      end
    end

    test "name changes, but user still has access from other group - membership should stay as is" do
      @user.update(groups: [ "old name", "other group" ])
      create(:access_rule, challenge: @challenge, group_name: "other group", roles: [ :participant ])
      @access_rule.update(group_name: "new name")

      assert_no_changes "Membership.count" do
        Memberships::UpdateRoles.new(challenge: @challenge.reload).call
      end
      assert @membership.has_role?(:manager)
    end

    test "role is changed to participant - membership is downgraded to participant" do
      @access_rule.update(roles: [ :manager ])

      Memberships::UpdateRoles.new(challenge: @challenge.reload).call

      assert @membership.reload.has_role?(:manager)
    end


    test "other group created with participant, membership stays as is" do
      @user.update(groups: [ "old name", "other group" ])
      create(:access_rule, challenge: @challenge, group_name: "other group", roles: [ :participant ])

      Memberships::UpdateRoles.new(challenge: @challenge.reload).call

      @membership.reload
      assert @membership.reload.has_role?(:manager)
    end

    test "role is changed to manager, but membership stays as is because of other group" do
      @user.update(groups: [ "old name", "other group" ])
      create(:access_rule, challenge: @challenge, group_name: "other group", roles: [ :manager ])

      @access_rule.update(roles: [ :participant ])
      Memberships::UpdateRoles.new(challenge: @challenge.reload).call

      assert @membership.reload.has_role?(:manager)
    end
  end
end
