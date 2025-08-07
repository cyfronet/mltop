module Challenges
  module Public
    class ApplicationController < ApplicationController
      allow_unauthenticated_access
      scoped_authentication :challenges, :public
    end
  end
end
