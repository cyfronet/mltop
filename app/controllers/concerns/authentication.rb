module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :restore_authentication
    before_action :store_return_to_url
    before_action :require_authentication
    helper_method :signed_in?
  end

  class_methods do
    def require_unauthenticated_access(**options)
      allow_unauthenticated_access(**options)
      before_action(:redirect_signed_in_user_to_root, **options)
    end

    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private
    def signed_in?
      Current.user.present?
    end

    def require_authentication
      signed_in? || redirect_to(sign_in_path)
    end

    def store_return_to_url
      cookies[:return_to_after_authenticating] = request.url if !signed_in?
    end

    def restore_authentication
      user = User.find_by(id: cookies.signed[:user_id])

      if user && (!user.from_plgrid? || user.credentials_valid?)
        authenticated_as(user)
      end
    end

    def redirect_signed_in_user_to_root
      redirect_to root_url if signed_in?
    end

    def post_authenticating_url(keep: false)
      method = keep ? :[] : :delete

      cookies.send(method, :return_to_after_authenticating) || root_url
    end

    def authenticated_as(user)
      Current.user = user
      cookies.signed.permanent[:user_id] = { value: user.id, httpsonly: true, same_site: :lax }
    end

    def reset_authentication
      cookies.delete(:user_id)
    end
end
