module Challenges
  module Dashboard
    class ApplicationController < ApplicationController
      scoped_authentication :challenges, :dashboard
    end
  end
end
