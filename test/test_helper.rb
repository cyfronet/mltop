ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "fixture_factory"
require "webmock/minitest"
require_relative "factories"
require "mocha/minitest"
require "minitest/autorun"

Dir[Rails.root.join("test/support/**/*.rb")].each { |f| require f }

CcmHelpers.default_ccm_stubs!

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    OmniAuth.config.test_mode = true

    def sign_in_as(name, teams: [ "plggmeetween" ])
      user = users(name)
      OmniAuth.config.add_mock(
        "plgrid",
        uid: user.uid,
        info: {
          name: user.name,
          email: user.email,
          nickname: user.plgrid_login
        },
        credentials: {
          token: CcmHelpers::VALID_TOKEN
        },
        extra: {
          raw_info: {
            groups: teams
          }
        },
      )
      get "/auth/plgrid/callback"
    end

    def github_sign_in_as(user)
      OmniAuth.config.add_mock(
        "plgrid",
        uid: user.uid,
        info: {
          name: user.name,
          email: user.email
        }
      )

      get "/auth/github/callback"
    end

    def in_challenge!(challenge = challenges(:global))
      self.default_url_options =
        { script_name: "/#{ChallengeSlug.encode(challenge.id)}" }
    end
  end

  WebMock.disable_net_connect!(allow_localhost: true)
end
