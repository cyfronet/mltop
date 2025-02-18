module Authorization
  extend ActiveSupport::Concern

  included do
    include Pundit::Authorization

    rescue_from Pundit::NotAuthorizedError do |_exception|
      redirect_back fallback_location: root_path,
                    alert: "You are not authorized to perform this action"
    end
  end

  class_methods do
    def meetween_members_only(**options)
      before_action(:require_meetween_member, **options)
    end
  end

  def current_user
    Current.user
  end

  private
    def require_meetween_member
      unless Current.user.meetween_member?
        flash.now[:alert] = "Only Meetween members can perform this action"
        render status: :forbidden
      end
    end
end
