source "https://rubygems.org"

gem "rails", github: "rails/rails", branch: "8-1-stable"

# freeze all strings
gem "freezolite"

gem "puma", ">= 5.0"

gem "pg", "~> 1.1"
gem "redis", ">= 4.0.1"

# active storage drivers
gem "aws-sdk-s3"

gem "propshaft"
gem "importmap-rails"

gem "solid_cache"
gem "solid_cable"
gem "solid_queue"
gem "mission_control-jobs"

gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails", "~> 4.0"
gem "image_processing", "~> 1.12"

gem "bootsnap", require: false

gem "omniauth-rails_csrf_protection"
gem "omniauth_openid_connect"
gem "omniauth-github", "~> 2.0.0"
gem "omniauth-google-oauth2"
gem "pundit"
gem "role_model"

gem "gretel"
gem "active_link_to"

# app security
gem "rack-attack"

gem "bcrypt", "~> 3.1.7"
gem "hpckit", github: "cyfronet/hpckit", branch: "slurm-client"

gem "kamal", ">= 2.0.0.rc2", require: false
gem "thruster", require: false

gem "rubyzip"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "bundler-audit", require: false
  gem "rubocop-rails-omakase", require: false
  gem "faker"
  gem "dotenv-rails"
  gem "prosopite"
  gem "pg_query" # for prosopite
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
  gem "mocha"
  gem "minitest-mock"
end

group :production do
  gem "sentry-ruby"
  gem "sentry-rails"
end
