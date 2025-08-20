require "test_helper"

class MembershipTest < ActiveSupport::TestCase
  setup do
    @challenge = challenges("global")
    @user = users("marek")
    @membership = Membership.new(user: @user, challenge: @challenge)
  end

  test "can join challenge without access rules" do
    @challenge.access_rules.destroy_all
    @user.update!(groups: [])

    assert @membership.valid?
  end

  test "can join challenge when have access rules satisfied" do
    @user.groups = [ "plggmeetween" ]
    assert @membership.valid?
  end

  test "cannot join challenge when access rules not satisfied" do
    @user.update!(groups: [ "other_group" ])

    assert_not @membership.valid?
  end

  test "admin membership is always valid" do
    @membership.roles = [ :admin ]
    assert @membership.valid?

    @user.update!(groups: [])
    assert @membership.valid?

    @challenge.access_rules.destroy_all
    assert @membership.valid?
  end
end
