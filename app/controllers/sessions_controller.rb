class SessionsController < ApplicationController
  require_unauthenticated_access only: [ :create, :new ]

  rescue_from Plgrid::Ccm::FetchError do
    external_error_log("Unable to fetch short ssh key for #{auth.info["nickname"]}")

    redirect_to root_path, alert: <<~MSG
      Failed to retrieve the short-lived SSH key.
      Our support team has been notified and is actively working to resolve the issue.
    MSG
  end

  def new
  end

  def create
    if user = user_provider.to_user
      authenticated_as(user)

      redirect_to post_authenticating_url, info: "Welcome back #{user.name}"
    else
      redirect_to root_path, alert: "Unable to authenticate"
    end
  end

  def destroy
    reset_authentication
    redirect_to root_path
  end

  private
    def auth
      request.env["omniauth.auth"]
    end

    def user_provider
      case params[:provider].to_s
      when "plgrid";        then Sso::Plgrid.from_omniauth(auth)
      when "github";        then Sso::Github.from_omniauth(auth)
      when "google_oauth2"; then Sso::Google.from_omniauth(auth)
      else                  Sso::Unknown.new
      end
    end
end
