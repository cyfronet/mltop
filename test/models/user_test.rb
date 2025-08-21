require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "check ssh credentials" do
    valid = build(:user, ssh_key: CredentialsProvider.key, ssh_certificate: CredentialsProvider.cert)
    assert valid.credentials_valid?

    invalid = build(:user, ssh_key: "invalid", ssh_certificate: "invalid")
    assert_not invalid.credentials_valid?
  end

  test "external users" do
    users("marek").update!(groups: [ "plggmeetween" ])
    users("szymon").update!(groups: [ "plggother" ])
    users("external").update!(groups: [ "plggother" ])

    Membership.create!(user: users("marek"), challenge: challenges(:global), roles: [ :manager ])
    Membership.create!(user: users("szymon"), challenge: challenges(:global), roles: [ :manager ])
    Membership.create!(user: users("external"), challenge: challenges(:global), roles: [])

    assert_equal [ users("external") ], User.external
  end
end
