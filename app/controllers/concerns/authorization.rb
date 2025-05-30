module Authorization
  extend ActiveSupport::Concern

  included do
    include Pundit::Authorization

    before_action :load_challenge
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
        respond_to do |format|
          format.html  {
            redirect_back fallback_location: root_path,
            alert: "Only Meetween members can manage external users submissions"
              }
          format.turbo_stream  {
              flash.now[:alert] = "Only Meetween members can perform this action"
              render status: :forbidden
          }
        end
      end
    end

    def load_challenge
      Current.challenge = Challenge.find_by(id: request.env["mltop.challenge_id"])
      # TODO uncomment this and change find_by to find
      # when we're ready to move to challenge scoped views
      # rescue ActiveRecord::RecordNotFound
      # raise Challenge::NotFoundError
    end
end
