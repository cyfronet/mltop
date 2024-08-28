redirect_uri = ENV["NGROK_HOST"].blank? ? "#{Rails.application.credentials.dig(:sso, :redirect_uri_base)}/auth/plgrid/callback" : "https://#{ENV.fetch("NGROK_HOST")}/auth/plgrid/callback"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :openid_connect,
    name: :sso,
    scope: [ :openid ],
    response_type: :code,
    issuer: "https://#{Rails.application.credentials.dig(:sso, :host)}/auth/realms/#{Rails.application.credentials.dig(:sso, :realm)}",
    discovery: true,
    client_options: {
      port: nil,
      scheme: "https",
      host: Rails.application.credentials.dig(:sso, :host),
      realm: Rails.application.credentials.dig(:sso, :realm),
      identifier: Rails.application.credentials.dig(:sso, :identifier),
      secret: Rails.application.credentials.dig(:sso, :secret),
      redirect_uri:
    }
end

OmniAuth.config.allowed_request_methods << :get
OmniAuth.config.silence_get_warning = true
