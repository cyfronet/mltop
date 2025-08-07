module Challenges
  class ApplicationController < ApplicationController
    scoped_authentication :challenges
  end
end
