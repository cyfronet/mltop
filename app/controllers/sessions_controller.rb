class SessionsController < ApplicationController
  allow_unauthenticated_access only: :create

  def create
    if uid
      if meetween_member?
        user = User.from_plgrid_omniauth(auth).tap { |u| u.save! }
        authenticated_as(user)

        redirect_to post_authenticating_url, info: "Welcome back #{name}"
      else
        redirect_to root_path, alert: "Only Meetween project members can login right now"
      end
    else
      redirect_to root_path, alert: "Unable to authenticate"
    end
  end

  def destroy
    reset_authentication
    redirect_to root_path
  end

  private
    def uid = auth && auth.uid
    def name = auth && auth.info["name"]
    def email = auth && auth.info["email"]
    def plgrid_login = auth && auth.info["nickname"]
    def teams = auth && auth.dig("extra", "raw_info", "groups") || []
    def token = auth && auth.dig("credentials", "token")

    def meetween_member?
      teams.include?("plggmeetween")
    end

    def auth
      request.env["omniauth.auth"]
    end
end
