class SessionsController < ApplicationController
  allow_unauthenticated_access only: :create

  def create
    if uid
      user = User.find_or_initialize_by(uid: uid)
      user.update(name:, email:, plgrid_login:)

      authenticated_as(user)

      redirect_to post_authenticating_url, info: "Welcome back #{name}"
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

    def auth
      request.env["omniauth.auth"]
    end
end
