Rails.application.config.middleware.use OmniAuth::Builder do
  provider :openid_connect,
    name: :plgrid,
    scope: [ :openid ],
    response_type: :code,
    issuer: "https://#{Rails.application.credentials.dig(:sso, :plgrid, :host)}/auth/realms/#{Rails.application.credentials.dig(:sso, :plgrid, :realm)}",
    discovery: true,
    client_options: {
      port: nil,
      scheme: "https",
      host: Rails.application.credentials.dig(:sso, :plgrid, :host),
      realm: Rails.application.credentials.dig(:sso, :plgrid, :realm),
      identifier: Rails.application.credentials.dig(:sso, :plgrid, :identifier),
      secret: Rails.application.credentials.dig(:sso, :plgrid, :secret)
    },
    setup: lambda { |env|
      request = Rack::Request.new(env)

      redirect_uri = [
        Rails.application.credentials.dig(:sso, :plgrid, :redirect_uri_base),
        request.script_name,
        "/auth/plgrid/callback"
      ].join

      env["omniauth.strategy"].options[:client_options][:redirect_uri] = redirect_uri
    }

  provider :github,
    Rails.application.credentials.dig(:sso, :github, :key),
    Rails.application.credentials.dig(:sso, :github, :secret)

  provider :google_oauth2,
    Rails.application.credentials.dig(:sso, :google, :key),
    Rails.application.credentials.dig(:sso, :google, :secret)
end
