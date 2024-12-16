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
      secret: Rails.application.credentials.dig(:sso, :plgrid, :secret),
      redirect_uri: "#{Rails.application.credentials.dig(:sso, :plgrid, :redirect_uri_base)}/auth/plgrid/callback"
    }

  provider :github,
    Rails.application.credentials.dig(:sso, :github, :key),
    Rails.application.credentials.dig(:sso, :github, :secret)
end
