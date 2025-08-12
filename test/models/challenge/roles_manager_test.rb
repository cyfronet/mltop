require "test_helper"

class Challenge::RolesManagerTest < ActiveSupport::TestCase
  setup do
    @challenge = create(:challenge)
    @access_rule = create(:access_rule, challenge: @challenge, group_name: "old name", roles: [ :manager ])
    @user = create(:user, groups: [ "old name" ])
    @membership = create(:membership, user: @user, challenge: @challenge, roles: [ :manager ])
  end


  test "membership should be deleted when it was only one granting user access" do
    @access_rule.update(group_name: "new name")

    assert_changes "Membership.count", -1 do
      @challenge.update_memberships
    end
  end

  test "name changes, but user still has access from other group - membership should stay as is" do
    @user.update(groups: [ "old name", "other group" ])
    create(:access_rule, challenge: @challenge, group_name: "other group", roles: [ :participant ])
    @access_rule.update(group_name: "new name")

    assert_no_changes "Membership.count" do
      @challenge.update_memberships
    end
    assert @membership.manager?
  end

  test "role is changed to participant - membership is downgraded to participant" do
    @access_rule.update(roles: [ :manager ])

    @challenge.update_memberships

    assert @membership.reload.manager?
  end


  test "other group created with participant, membership stays as is" do
    @user.update(groups: [ "old name", "other group" ])
    create(:access_rule, challenge: @challenge, group_name: "other group", roles: [ :participant ])

    @challenge.update_memberships

    @membership.reload
    assert @membership.reload.has_role?(:manager)
  end

  test "role is changed to manager, but membership stays as is because of other group" do
    @user.update(groups: [ "old name", "other group" ])
    create(:access_rule, challenge: @challenge, group_name: "other group", roles: [ :manager ])

    @access_rule.update(roles: [ :participant ])
    @challenge.update_memberships

    assert @membership.reload.manager?
  end
end
