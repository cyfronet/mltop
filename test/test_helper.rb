ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    OmniAuth.config.test_mode = true

    def sign_in_as(name)
      user = users(name)
      OmniAuth.config.add_mock(
        "sso",
        uid: user.uid,
        info: {
          name: user.name,
          email: user.email,
          nickname: user.plgrid_login
        }
      )
      get "/auth/sso/callback"
    end
  end
end
