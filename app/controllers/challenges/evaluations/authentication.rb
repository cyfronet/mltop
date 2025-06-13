module Challenges
  module Evaluations
    module Authentication
      extend ActiveSupport::Concern
      include ActionController::HttpAuthentication::Token::ControllerMethods

      included do
        before_action :require_authentication
      end

      private
        def require_authentication
          @evaluation = authenticate_or_request_with_http_token do |token, options|
            evaluation = Evaluation.authenticate_by(id: params[:evaluation_id], token:)
            evaluation if evaluation&.active?
          end
        end
    end
  end
end
