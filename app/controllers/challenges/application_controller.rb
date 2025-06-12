module Challenges
  class ApplicationController < ApplicationController
    def policy_scope(scope, **args)
      super([ :challenges, scope ], **args)
    end

    def authorize(record, query = nil)
      super([ :challenges, record ], query)
    end
  end
end
