require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require "freezolite/auto"
require File.expand_path("lib/challenge_slug")

module Mltop
  LANGUAGES = %w[be bg bs ca cs da de el en es et fi fr ga gl hr hu is it lb lt lv mk mt nl no pl pr pt ro ru sk sl sr sv th tr uk ar zh vi ko]

  def self.hpc_client(user, host, restd_runner = nil)
    Rails.configuration.hpc_client.constantize.for(user, host, restd_runner)
  end

  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    config.mission_control.jobs.base_controller_class = "Admin::ApplicationController"
    config.mission_control.jobs.http_basic_auth_enabled = false

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.middleware.use ChallengeSlug::Extractor
    config.middleware.use ChallengeSlug::LimitSessionToAccountSlugPath
    config.hpc_client = "::Hpc::Client"
  end
end
