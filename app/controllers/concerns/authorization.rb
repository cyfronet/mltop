module Authorization
  extend ActiveSupport::Concern

  included do
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError do |_exception|
      redirect_back fallback_location: root_path,
                    alert: "You are not authorized to perform this action"
    end
  end

  def current_user
    Current.user
  end
end
