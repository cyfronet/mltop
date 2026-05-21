module Challenges
  module Evaluations
    class ApplicationController < ActionController::API
      include Evaluations::Authentication

      rescue_from ActiveRecord::RecordInvalid do |e|
        render json: { message: e.message }, status: :unprocessable_entity
      end

      rescue_from ActionDispatch::Http::Parameters::ParseError do |e|
        render json: { message: "Invalid JSON" }, status: :bad_request
      end

      rescue_from ActionController::ParameterMissing do |e|
        render json: { message: "Missing parameter: #{e.param}" }, status: :bad_request
      end
    end
  end
end
