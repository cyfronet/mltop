# frozen_string_literal: true

require "test_helper"

module Plgrid
  class SshCredentialsTest < ActiveSupport::TestCase
    test "are valid for valid ssh credentials" do
      ssh_credentials = Plgrid::SshCredentials.new(
        CredentialsProvider.key, CredentialsProvider.cert)

      assert_predicate ssh_credentials, :valid?
    end

    test "is invalid for corrupted ssh credentials" do
      ssh_credentials = Plgrid::SshCredentials.new(
        CredentialsProvider.key, "invalid")
      assert_not_predicate ssh_credentials, :valid?
    end
  end
end
