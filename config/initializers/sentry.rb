# frozen_string_literal: true

if !Rails.env.local? && ENV["SENTRY_DSN"]
  Sentry.init do |config|
    config.dsn = ENV["SENTRY_DSN"]
    config.breadcrumbs_logger = [ :active_support_logger, :http_logger ]

    config.enabled_environments = %w[production staging iwslt]

    config.traces_sample_rate = 0.5

    config.send_default_pii = true
  end
end
