module Evaluations::Authentication
  extend ActiveSupport::Concern
  include ActionController::HttpAuthentication::Token::ControllerMethods

  included do
    before_action :require_authentication
  end

  private
    def require_authentication
      @evaluation = authenticate_or_request_with_http_token do |token, options|
        Evaluation.authenticate_by(id: params[:evaluation_id], token:)
      end
    end
end
