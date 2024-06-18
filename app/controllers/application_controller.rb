class ApplicationController < ActionController::Base
  include Authentication
  include Authorization
  include Sentryable

  allow_browser versions: :modern
end
