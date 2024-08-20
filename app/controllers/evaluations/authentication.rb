module Evaluations::Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
  end

  private
    def require_authentication
      @evaluation = Evaluation.authenticate_by(id: params[:evaluation_id], token:)
      render status: 401, json: { error: "Invalid evaluation or token." } unless @evaluation
    end

    def token
      pattern = /^Bearer /
      header = request.headers["HTTP_AUTHORIZATION"]

      header.gsub(pattern, "") if header&.match(pattern)
    end
end
