module Challenges
  module Dashboard
    class ApplicationController < ApplicationController
      scoped_authorization :challenges, :dashboard
    end
  end
end
