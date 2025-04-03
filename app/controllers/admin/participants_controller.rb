class Admin::ParticipantsController < Admin::ApplicationController
  def index
    @participants = User.all
  end
end
