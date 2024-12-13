require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "check ssh credentials" do
    valid = build(:user, ssh_key: CredentialsProvider.key, ssh_certificate: CredentialsProvider.cert)
    assert valid.credentials_valid?

    invalid = build(:user, ssh_key: "invalid", ssh_certificate: "invalid")
    assert_not invalid.credentials_valid?
  end

  test "external users" do
    assert_equal [ users("external") ], User.external
  end
end
