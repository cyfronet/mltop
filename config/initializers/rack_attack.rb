# frozen_string_literal: true

SUSPICOUS_PATHS = [
  %r{\A/ms-windows-store:/},
  %r{\A/dns-query.*},
  %r{\A/\?XDEBUG_SESSION_START=},
  %r{\A/actuator}
].freeze

Rack::Attack.blocklist("bots") do |request|
  Rack::Attack::Fail2Ban.filter("bot:#{request.ip}",
                                maxretry: 1, findtime: 1.minute, bantime: 1.hour) do
    SUSPICOUS_PATHS.any? { _1.match?(request.path) }
  end
end
