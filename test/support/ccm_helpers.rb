# frozen_string_literal: true

module CcmHelpers
  VALID_TOKEN = "valid-token"

  def self.default_ccm_stubs!
    ccm = WebMock::RequestPattern.new(:get, "#{Plgrid::Ccm::CCM_URI}?lifetime=1440")

    WebMock.globally_stub_request(:after_local_stubs) do |req|
      if ccm.matches?(req)
        if req.headers["Authorization"] == "Bearer #{VALID_TOKEN}"
          {
            status: 200,
            body: {
              cert: CredentialsProvider.cert,
              private: CredentialsProvider.key
            }.to_json
          }
        else
          { status: 401 }
        end
      end
    end
  end
end
