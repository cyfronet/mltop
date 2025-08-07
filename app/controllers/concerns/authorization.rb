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
    def scoped_authentication(*scopes)
      define_method :policy_scope do |scope, *args|
        super([ scopes, scope ].flatten, *args)
      end

      define_method :authorize do |record, *args|
        super([ scopes, record ].flatten, *args)
      end

      define_method :permitted_attributes do |record, *args|
        super([ scopes, record ].flatten, *args)
      end
    end
  end

  def current_user
    Current.user
  end

  private
    def load_challenge
      Current.challenge = Challenge.find_by(id: request.env["mltop.challenge_id"])
      # TODO uncomment this and change find_by to find
      # when we're ready to move to challenge scoped views
      # rescue ActiveRecord::RecordNotFound
      # raise Challenge::NotFoundError
    end
end
