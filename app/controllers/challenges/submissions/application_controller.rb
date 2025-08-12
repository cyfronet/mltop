module Challenges
  module Submissions
    class ApplicationController < ::ApplicationController
      scoped_authorization :challenges
    end
  end
end
