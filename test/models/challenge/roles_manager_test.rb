require "test_helper"

class Challenge::RolesManagerTest < ActiveSupport::TestCase
  setup do
    @challenge = create(:challenge)
    @access_rule = create(:access_rule, challenge: @challenge, group_name: "old name", roles: [ :manager ])
    @user = create(:user, groups: [ "old name" ])
    @membership = create(:membership, user: @user, challenge: @challenge, roles: [ :manager ])
    AccessRule.skip_callback(:commit, :after, :update_memberships)
  end

  teardown do
    AccessRule.set_callback(:commit, :after, :update_memberships)
  end

  test "membership should be deleted when user doesn't have required group" do
    @access_rule.update(group_name: "new name", required: true)

    assert_changes "Membership.count", -1 do
      @challenge.reload.update_memberships
    end
  end

  test "membership should be deleted when new required access rule is created user" do
    create(:access_rule, challenge: @challenge, group_name: "other group", required: true)
    assert_changes "Membership.count", -1 do
      @challenge.reload.update_memberships
    end
  end

  test "optional acces rule grants membership role" do
    @membership.update(roles: [ :participant ])

    @challenge.reload.update_memberships

    assert @membership.reload.manager?
  end

  test "name changes, but user still has access from other group - membership should stay as is" do
    @user.update(groups: [ "old name", "other group" ])
    create(:access_rule, challenge: @challenge, group_name: "other group", roles: [ :manager ])
    @access_rule.update(group_name: "new name")

    assert_no_changes "Membership.count" do
      @challenge.update_memberships
    end
    assert @membership.reload.manager?
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

    assert @membership.reload.has_role?(:manager)
  end

  test "role is changed to manager, but membership stays as is because of other group" do
    @user.update(groups: [ "old name", "other group" ])
    create(:access_rule, challenge: @challenge, group_name: "other group", roles: [ :manager ])

    @access_rule.update(roles: [ :participant ])
    @challenge.update_memberships

    assert @membership.reload.manager?
  end

  test "membership is not deleted when it has admin role, but manager is removed" do
    @access_rule.update(group_name: "new name")
    @membership.update(roles: [ :manager, :admin ])
    assert_no_changes "Membership.count" do
      @challenge.reload.update_memberships
    end

    assert @membership.reload.admin?
    assert_equal false, @membership.manager?
  end

  test "membership changes from participant to membership, but is still admin" do
    @access_rule.update(roles: [ :participant ])
    @membership.update(roles: [ :admin ])

    assert_no_changes "Membership.count" do
      @challenge.reload.update_memberships
    end

    assert @membership.reload.admin?
    assert @membership.participant?
  end

  test "#update_membership membership should be deleted when user doesn't have required group" do
    @access_rule.update(group_name: "new name", required: true)

    assert_changes "Membership.count", -1 do
      @challenge.update_membership(@membership)
    end
  end

  test "#update_membership membership should be deleted when new required access rule is created user" do
    create(:access_rule, challenge: @challenge, group_name: "other group", required: true)
    assert_changes "Membership.count", -1 do
      @challenge.update_membership(@membership)
    end
  end

  test "#update_membership optional acces rule grants membership role" do
    @membership.update(roles: [ :participant ])

    @challenge.reload.update_memberships

    assert @membership.reload.manager?
  end

  test "#update_membership name changes, but user still has access from other group - membership should stay as is" do
    @user.update(groups: [ "old name", "other group" ])
    create(:access_rule, challenge: @challenge, group_name: "other group", roles: [ :manager ])
    @access_rule.update(group_name: "new name")

    assert_no_changes "Membership.count" do
      @challenge.update_membership(@membership)
    end
    assert @membership.manager?
  end

  test "#update_membership role is changed to participant - membership is downgraded to participant" do
    @access_rule.update(roles: [ :manager ])

    @challenge.update_membership(@membership)

    assert @membership.manager?
  end

  test "#update_membership other group created with participant, membership stays as is" do
    @user.update(groups: [ "old name", "other group" ])
    create(:access_rule, challenge: @challenge, group_name: "other group", roles: [ :participant ])

    @challenge.update_membership(@membership)

    assert @membership.has_role?(:manager)
  end

  test "#update_membership role is changed to manager, but membership stays as is because of other group" do
    @user.update(groups: [ "old name", "other group" ])
    create(:access_rule, challenge: @challenge, group_name: "other group", roles: [ :manager ])

    @access_rule.update(roles: [ :participant ])
    @challenge.update_membership(@membership)

    assert @membership.manager?
  end

  test "#update_membership membership is not deleted when it has admin role, but manager is removed" do
    @access_rule.update(group_name: "new name")
    @membership.update(roles: [ :manager, :admin ])
    assert_no_changes "Membership.count" do
      @challenge.reload.update_membership(@membership)
    end

    assert @membership.reload.admin?
    assert_equal false, @membership.manager?
  end

  test "#update_membership membership changes from participant to membership, but is still admin" do
    @access_rule.update(roles: [ :participant ])
    @membership.update(roles: [ :admin ])

    assert_no_changes "Membership.count" do
      @challenge.reload.update_membership(@membership)
    end

    assert @membership.reload.admin?
    assert @membership.participant?
  end
end
