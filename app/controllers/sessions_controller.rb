class SessionsController < ApplicationController
  allow_unauthenticated_access only: :create

  rescue_from Plgrid::Ccm::FetchError do
    external_error_log("Unable to fetch short ssh key for #{auth.info["nickname"]}")

    redirect_to root_path, alert: <<~MSG
      Failed to retrieve the short-lived SSH key.
      Our support team has been notified and is actively working to resolve the issue.
    MSG
  end

  def create
    plgrid_user = Plgrid::User.from_omniauth(auth)

    if user = plgrid_user.to_user
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
end
