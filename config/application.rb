require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require "freezolite/auto"

module Mltop
  LANGUAGES = %w[be bg bs ca cs da de el en en es et fi fr ga gl hr hu is it lb lt lv mk mt nl no pl pr pt ro ru sk sl sr sv th tr uk]

  def self.hpc_client(user, host)
    Rails.configuration.hpc_client.constantize.for(user, host)
  end

  def self.ranking_released?
    Current.user&.meetween_member? ||
      Rails.configuration.ranking_released
  end

  def self.challenge_open?
    Time.now.between?(Rails.configuration.challange_open_time,
                      Rails.configuration.challange_close_time)
  end

  def self.challange_closed?
    !Mltop.challange_open?
  end

  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

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
    config.hpc_client = "::Hpc::Client"

    config.ranking_released = ENV["RANKING_RELEASED"] == "true"
    config.challange_open_time = Time.parse(ENV["CHALLANGE_OPEN_TIME"]) rescue Time.now
    config.challange_close_time = Time.parse(ENV["CHALLANGE_CLOSE_TIME"]) rescue Time.now  + 1.day
  end
end
