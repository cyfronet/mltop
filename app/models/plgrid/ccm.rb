# frozen_string_literal: true

require "net/http"

class Plgrid::Ccm
  CCM_URI = URI.parse(Rails.application.credentials.dig(:ccm, :uri))
  LIFETIME = 24 * 60

  class FetchError < StandardError; end

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
        Error while fetching short lived ssh key
          - status code: #{response.code}
          - error body: #{response.body}
      ERROR

      raise FetchError, "Cannot fetch short lived ssh key (#{response.code} response code)"
    end
  rescue Net::ReadTimeout
    raise FetchError, "Cannot fetch short lived ssh key (read timeout)"
  rescue StandardError
    raise FetchError, "Cannot fetch short lived ssh key"
  end

  private
    def make_request
      Net::HTTP.start(CCM_URI.host, CCM_URI.port,
                      use_ssl: CCM_URI.is_a?(URI::HTTPS),
                      open_timeout: 1, read_timeout: 2) do |http|
        # TODO: Remove query param once CCM fixes the issue with not accepting
        #       lifetime as form data.
        url = CCM_URI.dup
        url.query = URI.encode_www_form(lifetime: LIFETIME)

        req = Net::HTTP::Post.new(url)
        req["Authorization"] = "Bearer #{@token}"
        req.set_form_data("lifetime" => LIFETIME)

        http.request(req)
      end
    end
end
