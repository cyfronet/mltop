class Admin::ParticipantsController < Admin::ApplicationController
  def index
    @participants = User.preload(models: :hypothesis).all
  end
end
