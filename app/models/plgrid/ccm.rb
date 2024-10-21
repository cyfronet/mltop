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
    case make_request
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

  private
    def make_request
      Net::HTTP.start(CCM_URI.host, CCM_URI.port,
                      use_ssl: CCM_URI.is_a?(URI::HTTPS),
                      open_timeout: 1, read_timeout: 2) do |http|
        req = Net::HTTP::Post.new(CCM_URI)
        req["Authorization"] = "Bearer #{@token}"
        req.set_form_data("lifetime" => LIFETIME)

        http.request(req)
      end
    end
end
