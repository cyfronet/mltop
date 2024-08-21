module Tokenable
  extend ActiveSupport::Concern

  included do
    has_secure_password :token, validations: false
  end

  def reset_token!
    generate_token.tap do |token|
      update! token:
    end
  end

  private
    def generate_token
      SecureRandom.alphanumeric(12).scan(/.{4}/).join("-")
    end
end
