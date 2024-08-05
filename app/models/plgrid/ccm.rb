# frozen_string_literal: true

require "net/http"

class Plgrid::Ccm
  CCM_URI = URI.parse(Rails.application.credentials.dig(:ccm, :uri))
  LIFETIME = 24 * 60

  attr_reader :certificate, :key

  def initialize(token)
    @token = token
  end

  def fetch!
    url = CCM_URI.dup
    url.query = URI.encode_www_form(lifetime: LIFETIME)
    case Net::HTTP.get_response(url, "Authorization" => "Bearer #{@token}")
    in Net::HTTPOK => response
      json_response = JSON.parse(response.body)
      @certificate = json_response["cert"]
      @key = json_response["private"]
    in _ => response
      Rails.logger.warn <<~ERROR
        Error while fetching short lived ssh key with correct user token
          - status code: #{response.code}
          - error body: #{response.body}
      ERROR

      raise "Cannot fetch short lived ssh key"
    end
  end
end
