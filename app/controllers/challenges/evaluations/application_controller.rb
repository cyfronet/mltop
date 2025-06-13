module Challenges
  module Evaluations
    class ApplicationController < ActionController::API
      include Evaluations::Authentication

      rescue_from ActiveRecord::RecordInvalid do |e|
        render json: { message: e.message }, status: :unprocessable_entity
      end
    end
  end
end
