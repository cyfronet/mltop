source "https://rubygems.org"

gem "rails", github: "rails/rails", branch: "main"

gem "puma", ">= 5.0"

gem "pg", "~> 1.1"
gem "redis", ">= 4.0.1"

gem "propshaft"
gem "importmap-rails"

gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"

gem "bootsnap", require: false

gem "omniauth_openid_connect"

gem "gretel"
gem "active_link_to"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
  gem "faker"
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
end

gem "image_processing", "~> 1.12"
