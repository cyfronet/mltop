class ErrorsController < ApplicationController
  allow_unauthenticated_access

  def not_found
  end

  def server_error
  end
end
