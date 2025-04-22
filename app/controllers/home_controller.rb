# frozen_string_literal: true

class HomeController < ApplicationController
  allow_unauthenticated_access

  def index
    @challenges = Challenge.all
    @stats = Statistics.new
  end
end
