require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "Meetween user needs to have valid ssh credentials" do
    marek = create(:user, roles: [ :meetween_member ],
      ssh_key: "invalid", ssh_certificate: "invalid")

    assert_not marek.credentials_valid?
  end
end
