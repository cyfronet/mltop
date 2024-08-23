source "https://rubygems.org"

gem "rails", "~> 7.2.0"

gem "puma", ">= 5.0"

gem "pg", "~> 1.1"
gem "redis", ">= 4.0.1"

gem "propshaft"
gem "importmap-rails"

gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "image_processing", "~> 1.12"

gem "bootsnap", require: false

gem "omniauth_openid_connect"
gem "pundit"
gem "role_model"

gem "gretel"
gem "active_link_to"

# app security
gem "rack-attack"

gem "bcrypt", "~> 3.1.7"
gem "hpckit", github: "cyfronet/hpckit", branch: "slurm-client"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "faker"
  gem "dotenv-rails"
end

group :development do
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "fixture_factory"
  gem "webmock", "~> 3.10"
end

group :production do
  gem "sentry-ruby"
  gem "sentry-rails"
end
