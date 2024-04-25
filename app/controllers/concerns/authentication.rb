module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :restore_authentication
    before_action :require_authentication
    helper_method :signed_in?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def signed_in?
      Current.user.present?
    end

    def require_authentication
      signed_in? || request_authentication
    end

    def restore_authentication
      if user = User.find_by(id: cookies.signed[:user_id])
        authenticated_as(user)
      end
    end

    def request_authentication
      session[:return_to_after_authenticating] = request.url
      redirect_to sign_in_path
    end

    def post_authenticating_url
      session.delete(:return_to_after_authenticating) || root_url
    end

    def authenticated_as(user)
      Current.user = user
      cookies.signed.permanent[:user_id] = { value: user.id, httpsonly: true, same_site: :lax }
    end

    def reset_authentication
      cookies.delete(:user_id)
    end
end
