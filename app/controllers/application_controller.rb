class ApplicationController < ActionController::Base
  include Authentication
  include Authorization
  include Sentryable

  allow_browser versions: :modern

  def render_404
    render file: "#{Rails.root}/public/404", status: :not_found
  end
end
