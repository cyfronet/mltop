require "test_helper"

module Memberships
  class UpdateRolesTest < ActiveSupport::TestCase
    setup do
      @challenge = create(:challenge)
      @allowed_group = create(:allowed_group, challenge: @challenge, group_name: "old name", roles: [ :manager ])
      @user = create(:user)
      create(:group, user: @user, name: "old name")
      @membership = create(:membership, user: @user, challenge: @challenge, roles: [ :manager ])
    end


    test "memberhip should be deleted when it was only one granting user access" do
      @allowed_group.update(group_name: "new name")

      assert_changes "Membership.count", -1 do
        Memberships::UpdateRoles.new(challenge: @challenge.reload).call
      end
    end

    test "name changes, but user still has access from other group - membership should stay as is" do
      create(:group, user: @user, name: "other group")
      create(:allowed_group, challenge: @challenge, group_name: "other group", roles: [ :participant ])

      @allowed_group.update(group_name: "new name")


      assert_no_changes "Membership.count" do
        Memberships::UpdateRoles.new(challenge: @challenge.reload).call
      end
      assert @membership.has_role?(:manager)
    end

    test "role is changed to participant - membership is downgraded to participant" do
      @allowed_group.update(roles: [ :manager ])

      Memberships::UpdateRoles.new(challenge: @challenge.reload).call

      assert @membership.reload.has_role?(:manager)
    end


    test "other group created with participant, membership stays as is" do
      create(:group, user: @user, name: "other group")
      create(:allowed_group, challenge: @challenge, group_name: "other group", roles: [ :participant ])

      Memberships::UpdateRoles.new(challenge: @challenge.reload).call

      @membership.reload
      assert @membership.reload.has_role?(:manager)
    end

    test "role is changed to manager, but membership stays as is because of other group" do
      create(:group, user: @user, name: "other group")
      create(:allowed_group, challenge: @challenge, group_name: "other group", roles: [ :manager ])

      @allowed_group.update(roles: [ :participant ])
      Memberships::UpdateRoles.new(challenge: @challenge.reload).call

      assert @membership.reload.has_role?(:manager)
    end
  end
end
