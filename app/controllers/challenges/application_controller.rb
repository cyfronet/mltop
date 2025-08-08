module Challenges
  class ApplicationController < ApplicationController
    scoped_authorization :challenges
  end
end
