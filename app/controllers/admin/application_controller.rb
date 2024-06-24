class Admin::ApplicationController < ApplicationController
  before_action do
    unless Current.user.admin?
      redirect_back fallback_location: root_path,
        alert: "Your are not authorized to perform this action"
    end
  end
end
